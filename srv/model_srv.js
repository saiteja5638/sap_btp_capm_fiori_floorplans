var cds = require('@sap/cds');
const { INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');
const axios = require('axios');

const Ext = require('./license-service')

const BASE_URL = 'https://services.odata.org/v4/Northwind/northwind.svc';

// Optional: restrict to known entity sets to avoid arbitrary path injection
const ALLOWED_ENTITIES = [
    'Categories', 'CustomerDemographics', 'Customers', 'Employees',
    'Order_Details', 'Orders', 'Products', 'Regions', 'Shippers',
    'Suppliers', 'Territories'
];


module.exports = srv => {



    srv.on("createPlanning", async (req) => {

        // 1. Validate the license first
        try {
            await licenseService.validateLicense();
        } catch (error) {
            return req.reject(
                error.status || 503,
                "License validation failed"
            );
        }

        // 2. Execute your existing planning logic
        // Do not remove your existing implementation.

    });



    srv.before(['READ'], 'Employees1', async (req) => {
        try {
            console.log(req)
        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on('getEntityData', async (req) => {
        const { entityName } = req.data;

        if (!entityName) {
            return req.error(400, 'entityName is required');
        }

        if (!ALLOWED_ENTITIES.includes(entityName)) {
            return req.error(400, `Unknown entity: ${entityName}`);
        }

        try {
            const response = await axios.get(`${BASE_URL}/${entityName}`, {
                headers: { Accept: 'application/json' },
                timeout: 10000
            });

            // Northwind OData v4 wraps results in { "@odata.context": ..., "value": [...] }
            return response.data.value;

        } catch (err) {
            req.error(502, `Failed to fetch ${entityName} from Northwind: ${err.message}`);
        }
    });
    srv.on('insertData', async (req) => {
        try {



            let payload = [
                { "id": 1, "name": "Alice", "age": 28, "city": "Hyderabad" },
                { "id": 2, "name": "Bob", "age": 34, "city": "Bangalore" },
                { "id": 3, "name": "Charlie", "age": 25, "city": "Mumbai" },
                { "id": 4, "name": "Diana", "age": 31, "city": "Delhi" },
                { "id": 5, "name": "Ethan", "age": 27, "city": "Chennai" }
            ]

            let String = JSON.stringify(payload)

            return {
                Messsage: JSON.parse(String)
            }




        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on('READ', 'EmployeesByStatus', async (req) => {
        try {
            const employees = await cds.run('SELECT  "STATUS" as status FROM MODEL_EMPLOYEES');

            const counts = {};
            employees.forEach(e => {
                const status = e.STATUS;
                counts[status] = (counts[status] || 0) + 1;
            });

            return Object.entries(counts).map(([status, employeeCount]) => ({
                status,
                employeeCount
            }));

        } catch (error) {
            console.log(error.message);
            return req.error(500, 'Failed to compute employee status counts');
        }
    });
    srv.after('READ', 'WarehouseStock', (results) => {
        const rows = Array.isArray(results) ? results : [results];
        rows.forEach(row => {
            if (!row) return;
            if (row.quantity < row.reorderLevel * 0.5) {
                row.stockCriticality = 1;   // Negative (red)
            } else if (row.quantity < row.reorderLevel) {
                row.stockCriticality = 2;   // Critical (orange)
            } else {
                row.stockCriticality = 3;   // Positive (green)
            }
        });
    });
    srv.on('promote', 'Employees', async (req) => {
        try {
            let Salary = req.data.Salary;
            let EmpId = req.params[0].ID;

            let EmpExists = await cds.run(`SELECT * FROM MODEL_EMPLOYEES where EMPLOYEEID ='${EmpId}'`)

            if (EmpExists.length > 0) {

                let EmppromtedSalary = Number(EmpExists[0].SALARY) + Salary;
                await UPDATE("MODEL_EMPLOYEES").set({
                    salary: EmppromtedSalary,
                    status: 'Promoted'
                }).where({
                    EMPLOYEEID: EmpId
                })
                let EmpUpdateSalary = await cds.run(`SELECT * FROM MODEL_EMPLOYEES where EMPLOYEEID ='${EmpId}'`)

                return EmpUpdateSalary

            }
            else {
                req.reject({
                    StatusCode: 400,
                    StatusMessage: 'Employeee Does Not Exits'
                })
            }

        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on(['CREATE'], 'Salesorder', async (req) => {
        try {

            let SalesOrder = req.data;

            let CheckCust = await cds.run(`SELECT * FROM MODEL_CUSTOMERS where CUSTNAME = '${SalesOrder.CUSTOMER}';`)

            if (CheckCust.length > 0) {

                let CheckWareHouse = await cds.run(`SELECT * FROM MODEL_WAREHOUSEMGMT where PROD ='${SalesOrder.PRODUCT}' and LOC = '${SalesOrder.LOCATION}'`)

                let getprodprice = await cds.run(`SELECT  * FROM MODEL_PRODUCTS where PRODUCTNAME ='${SalesOrder.PRODUCT}'`)


                let ReturnResponse = {
                    SalesOrderId: cds.utils.uuid(),
                    CUSTOMER: SalesOrder.CUSTOMER,
                    PRODUCT: SalesOrder.PRODUCT,
                    LOCATION: SalesOrder.LOCATION,
                    Quantity: SalesOrder.Quantity,
                    PRICE: (SalesOrder.Quantity * getprodprice[0].PROD_PRICE)
                }

                return ReturnResponse


            } else {

                req.reject({
                    StatusCode: 400,
                    StatusMessage: 'Customer Is Not Existing'
                })

            }

        } catch (error) {
            console.log(error.message)
        }

    })
    srv.on('getSalarybyEmployee', async (req) => {
        try {

            let getRecords = await cds.run(`SELECT
	"NAME",
	"SALARY",
	"JOBTITLE"
FROM MODEL_EMPLOYEES`)

            if (getRecords.length > 0) {

                return {
                    StatusCode: 200,
                    Response: getRecords
                }


            }
            else {
                return {
                    StatusCode: 200,
                    Response: 'No Records Are Existing'
                }
            }

        } catch (error) {
            console.log(error.message)
        }
    })
    srv.before(['CREATE'], 'Candidates', async (req) => {
        try {
            let payload = req.data;

            if (payload.CNAME == null || payload.CNAME == undefined || payload.CNAME == "") {
                req.reject(400)
            }
            if (payload.CEMAIL == null || payload.CEMAIL == undefined || payload.CEMAIL == "") {
                req.reject(400)
            }
            if (payload.CNUMBER == null || payload.CNUMBER == undefined || payload.CNUMBER == "") {
                req.reject(400)
            }
        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on(['CREATE'], 'Candidates', async (req) => {
        try {
            let payload = req.data;

            let getCand = await cds.run(`SELECT  * FROM MODEL_CANDIDATES WHERE CID = '${payload.CID}' AND CNAME = '${payload.CNAME}'`)

            if (getCand.length > 0) {

                req.reject(400, 'Candidates is Already Existing')

            }
            else {
                payload['Applied'] = true;
                payload['CJOB_APPLICATION'] = 'SAPBTPCAPMDEV';
                payload['CJOB_STATUS'] = 'SCREENING';
                await cds.run(INSERT.into("MODEL_CANDIDATES").entries(payload))

                req.reply({
                    StatusCode: 200,
                    StatusMessage: "Successfully Created"
                })
            }

        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on('SalesOrderBatch', async (req, res) => {
        try {

            let payload = req.data.SalesOrders;

            let UpdateAutoGenId = payload.map(i => {
                i['SalesOrdId'] = cds.utils.uuid()
                return i
            })

            await cds.run(INSERT.into("MODEL_SALESORDER").entries(UpdateAutoGenId))

            return {
                Messsage: {
                    StatusCode: 200,
                    StatusMessage: 'SuccessFully Records got Created'
                }
            }

        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on('READ', 'EmployeesByDepartment', async (req) => {
        try {
            const employees = await cds.run(`SELECT
    E."DEPARTMENT_ID",
    D."NAME" AS "department"
FROM MODEL_EMPLOYEES E
LEFT JOIN "MODEL_DEPARTMENTS" D
    ON E."DEPARTMENT_ID" = D."ID";`)
            const counts = {};
            employees.forEach(e => {
                const dept = e.department || 'Unassigned';
                counts[dept] = (counts[dept] || 0) + 1;
            });
            return Object.entries(counts).map(([department, employeeCount]) => ({ department, employeeCount }));
        } catch (error) {
            console.log(error.message);
            return req.error(500, 'Failed to compute employee counts by department');
        }
    });
    srv.on('READ', 'LeaveRequestsByMonth', async (req) => {
        try {
            const leaves = await cds.run('SELECT "FROMDATE" FROM MODEL_LEAVEREQUESTS')
            const counts = {};
            leaves.forEach(l => {
                if (!l.FROMDATE) return;
                const month = String(l.FROMDATE).substring(0, 7); // "YYYY-MM"
                counts[month] = (counts[month] || 0) + 1;
            });
            return Object.entries(counts)
                .sort(([a], [b]) => a.localeCompare(b))
                .map(([month, leaveCount]) => ({ month, leaveCount }));
        } catch (error) {
            console.log(error.message);
            return req.error(500, 'Failed to compute leave requests by month');
        }
    });
    srv.on('READ', 'DepartmentAttrition', async (req) => {
        try {
            const employees = await cds.run(`SELECT
    D."NAME" AS "department",
    E."STATUS" AS "status"
FROM "MODEL_EMPLOYEES" E
LEFT JOIN "MODEL_DEPARTMENTS" D
    ON E."DEPARTMENT_ID" = D."ID";`)

            const stats = {};
            employees.forEach(e => {
                const dept = e.department || 'Unassigned';
                if (!stats[dept]) stats[dept] = { total: 0, inactive: 0 };
                stats[dept].total++;
                if (e.status && e.status.toLowerCase() === 'inactive') stats[dept].inactive++;
            });
            return Object.entries(stats).map(([department, s]) => ({
                department,
                headcount: s.total,
                attritionRate: s.total ? Number(((s.inactive / s.total) * 100).toFixed(1)) : 0
            }));
        } catch (error) {
            console.log(error.message);
            return req.error(500, 'Failed to compute department attrition');
        }
    });
    srv.on('getDataByParam', async (req) => {
        try {
            let payload = req.data;

            var getRecords;

            if (payload.TableName = 'Employees') {

                getRecords = await cds.run(`select * from MODEL_EMPLOYEES1 limit ${payload.Limit};`)

            }
            if (payload.TableName = 'Leaves') {

                getRecords = await cds.run(`select * from MODEL_LEAVEREQUESTS limit ${payload.Limit};`)

            }
            if (payload.TableName = 'Products') {

                getRecords = await cds.run(`select * from MODEL_PRODUCT limit ${payload.Limit};`)

            }

            return {
                Records: getRecords
            }

        } catch (error) {
            console.log(error.message)
        }
    })
    srv.on('READ', 'EmployeeSalaryTenure', async (req) => {
        try {
            const employees = await cds.run(`SELECT 
	"CREATEDAT",
	"EMPLOYEEID",
	"NAME",
	"SALARY"
FROM MODEL_EMPLOYEES`);

            const now = new Date();
            return employees.map(e => {
                const created = e.CREATEDAT ? new Date(e.CREATEDAT) : now;
                const tenureYears = Number(((now - created) / (1000 * 60 * 60 * 24 * 365)).toFixed(1));
                return { employeeId: e.EMPLOYEEID, name: e.NAME, salary: e.SALARY, tenureYears };
            });
        } catch (error) {
            console.log(error.message);
            return req.error(500, 'Failed to compute employee salary/tenure');
        }
    });
    srv.on('READ', 'LeaveTypeByDepartment', async (req) => {
        try {
            const leaves = await cds.run(`SELECT
    L."LEAVETYPE" AS "leaveType",
    D."NAME" AS "department"
FROM "MODEL_LEAVEREQUESTS" L
LEFT JOIN "MODEL_EMPLOYEES" E
    ON L."EMPLOYEE_ID" = E."ID"
LEFT JOIN "MODEL_DEPARTMENTS" D
    ON E."DEPARTMENT_ID" = D."ID";`)

            const counts = {};
            leaves.forEach(l => {
                const dept = l.department || 'Unassigned';
                const key = `${l.leaveType}||${dept}`;
                counts[key] = (counts[key] || 0) + 1;
            });
            return Object.entries(counts).map(([key, leaveCount]) => {
                const [leaveType, department] = key.split('||');
                return { leaveType, department, leaveCount };
            });
        } catch (error) {
            console.log(error.message);
            return req.error(500, 'Failed to compute leave type by department');
        }
    });
}
