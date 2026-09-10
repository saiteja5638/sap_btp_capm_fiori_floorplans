using model from '../db/model';


service CatalogService {

    entity EmployeesByStatus {
        key status                : String;
            virtual employeeCount : Integer;
    }

    entity Users           as projection on model.Users;

    entity Salesorder      as projection on model.Salesorder;


    entity SalesOrders     as projection on model.SalesOrders;
    entity SalesOrderItems as projection on model.SalesOrderItems;

    entity Employees1      as projection on model.Employees1;
    entity ProjectInfo     as projection on model.ProjectInfo;
    entity SkillSet        as projection on model.SkillSet;
    entity WorkExp         as projection on model.WorkExp;


    entity Empl            as projection on model.Empl;

    entity Candidates      as projection on model.Candidates;

    @readonly
    entity Employees       as projection on model.Employees;

    @readonly
    entity Departments     as projection on model.Departments;

    @readonly
    entity LeaveRequests   as projection on model.LeaveRequests;


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

    action SalesOrderBatch(SalesOrders: array of SalesOrderType) returns Reponse;


}
