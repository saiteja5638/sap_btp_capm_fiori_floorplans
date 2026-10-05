using model from '../db/model';


service CatalogService {

    entity EmployeesByStatus {
        key status                : String;
            virtual employeeCount : Integer;
    }


    entity Books           as projection on model.Books;
    entity Customers       as projection on model.Customers;

    entity PurchaseOrders  as
        projection on model.PurchaseOrders {
            PID as PurchaseOrderID,
            Customer as CustomerName
        };

    entity Book            as projection on model.Book;
    entity Authors         as projection on model.Authors;

    entity ManagedUsers    as projection on model.ManagedUsers;
    entity MCHILDS         as projection on model.MCHILDS;


    // entity POPID_V         as projection on POPID;


    entity Orders          as projection on model.Orders;
    entity OrderItems      as projection on model.OrderItems;
    entity Users           as projection on model.Users;

    entity Salesorder      as projection on model.Salesorder;


    entity SalesOrders     as projection on model.SalesOrders;
    entity SalesOrderItems as projection on model.SalesOrderItems;

    @restrict: [
        {
            grant: 'READ',
            to   : 'READPROD'
        },
        {
            grant: [
                'READ',
                'CREATE'
            ],
            to   : 'CREATEPROD'
        },
        {
            grant: [
                'READ',
                'UPDATE'
            ],
            to   : 'UPDATEPROD'
        },
        {
            grant: [
                'READ',
                'DELETE'
            ],
            to   : 'DELETEPROD'
        }
    ]
    @odata.draft.enabled
    entity Employees1      as projection on model.Employees1;
    entity ProjectInfo     as projection on model.ProjectInfo;
    entity SkillSet        as projection on model.SkillSet;
    entity WorkExp         as projection on model.WorkExp;


    entity Empl            as projection on model.Empl;

    entity Candidates      as projection on model.Candidates;


    entity Employees       as projection on model.Employees
        actions {
            action promote(Salary: Decimal(10, 2)) returns Employees
        };


    @readonly
    entity Departments     as projection on model.Departments;

    @readonly
    entity LeaveRequests   as projection on model.LeaveRequests;


    entity Products        as projection on model.Product;
    entity WarehouseStock  as projection on model.WarehouseStock;

    entity EMPLOYEES22     as projection on model.EMPLOYEES22;
    // entity Managers        as projection on model.Managers;

    entity EMPLOYEE as  select EMPID from model.EMPLOYEES22;


    entity EmployeesByDepartment {
        key department            : String;
            virtual employeeCount : Integer;
    }

    entity LeaveRequestsByMonth {
        key month              : String;
            virtual leaveCount : Integer;
    }

    entity DepartmentAttrition {
        key department            : String;
            virtual headcount     : Integer;
            virtual attritionRate : Decimal;
    }

    entity EmployeeSalaryTenure {
        key employeeId          : String;
            virtual name        : String;
            virtual salary      : Decimal;
            virtual tenureYears : Decimal;
    }

    entity LeaveTypeByDepartment {
        key leaveType          : String;
        key department         : String;
            virtual leaveCount : Integer;
    }

    type SalesOrderType {
        CUSTOMER : String;
        PRODUCT  : String;
        LOCATION : String;
        Quantity : String;
        PRICE    : String;
    }

    type Reponse {
        Messsage : String;
    }

    action   SalesOrderBatch(SalesOrders: array of SalesOrderType) returns Reponse;

    action   insertData(payload: String)                           returns Reponse;

    function getDataByParam(TableName: String, Limit: Integer)     returns String;


    function getSalarybyEmployee()                                 returns String;

    function getEntityData(entityName: String)                     returns array of {};


}
