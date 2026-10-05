using {
    cuid,
    managed,
    User
} from '@sap/cds/common';

context model {
    entity Users {
        key ID   : String;
            NAME : String;
    }

    entity Customers {
        key CustID   : String;
        key PID      : UUID;
        key KID      : UUID;
            CustName : String;

            orders   : Association to many PurchaseOrders
                           on orders.Customer = $self.KID;
    }

    entity PurchaseOrders {
        key PID      : UUID;
            PNUMBER  : Integer;
            PRICE    : Double;
            Customer : String;
    }


    entity Product : cuid, managed {
        productName : String(100);
        category    : String(50);
        price       : Decimal(10, 2);
    }


    // assocaitions with un managed
    entity Books {
        key ID     : UUID;
            title  : String;
            author : Association to Authors;
    }

    entity Authors {
        key ID    : UUID;
            name  : String;
            books : Association to many Books
                        on books.author = $self;
    }

    // assocaitions with managed
    entity ManagedUsers {
        key MID   : UUID;
            MNAME : String;
            mc    : Association to many MCHILDS
                        on mc.CID = $self.MID;

    }

    entity MCHILDS {
        key MCID    : UUID;
            CID     : String(36);
            TITLE   : String(36);
            DESCRIP : String(40);
    }


    entity Orders {
        key ID    : UUID;
            items : Composition of many OrderItems
                        on items.order = $self;
    }

    entity OrderItems {
        key ID       : UUID;
            order    : Association to Orders;
            product  : String;
            quantity : Integer;
    }


    aspect cuid {
        key ID : UUID;
    }

    aspect managed {
        createdAt  : Timestamp  @cds.on.insert: $now;
        createdBy  : User       @cds.on.insert: $user;
        modifiedAt : Timestamp  @cds.on.insert: $now   @cds.on.update: $now;
        modifiedBy : User       @cds.on.insert: $user  @cds.on.update: $user;
    }

    entity Book : cuid, managed {
        title : String;
        price : Decimal;
    }


    entity WarehouseStock : cuid, managed {
        product                  : String(100);
        location                 : String(50);
        quantity                 : Integer;
        reorderLevel             : Integer default 10;
        virtual stockCriticality : Integer;
    }

    entity wareHouseMgmt {
        key WID       : String;
            PROD      : String;
            LOC       : String;
            AVAIL_QTY : String;
    }

    entity Salesorder {
        key SalesOrdId : UUID;
            CUSTOMER   : String;
            PRODUCT    : String;
            LOCATION   : String;
            Quantity   : String;
            PRICE      : String;
    }


    entity Employees1 : cuid, managed {
        employeeId  : String(10);
        name        : String(100);
        email       : String(100);
        department  : String(50);
        designation : String(100);
        salary      : Decimal(15, 2);
        status      : String(20);

        project     : Association to one ProjectInfo;

        skillset    : Composition of many SkillSet
                          on skillset.employee = $self;

        wexp        : Composition of many WorkExp
                          on wexp.employee = $self;
    }


    entity ProjectInfo : cuid {

        PTitle       : String(100);
        PDescription : String(500);
        PStartedDate : Date;
        PEndDate     : Date;
        PType        : String(50);
        TeamSize     : Integer;

        employees    : Association to many Employees1
                           on employees.project = $self;
    }


    entity WorkExp : cuid {

        CompanyName : String(100);
        CompanyType : String(50);
        Status      : Boolean;
        Exp         : Integer;
        StartDate   : Date;
        EndDate     : Date;

        employee    : Association to one Employees1;
    }


    entity SkillSet : cuid {

        STitle   : String(100);
        SDescrip : String(500);
        Slevel   : Integer;

        employee : Association to one Employees1;
    }


    entity SalesOrders {
        key ID          : Integer;
        key orderNumber : String(20);
        key customer    : String(100);

            items       : Composition of many SalesOrderItems
                              on items.order = $self;
    }

    entity SalesOrderItems {
        key ID       : Integer;
            product  : String(100);
            quantity : Integer;
            price    : Decimal(10, 2);

            order    : Association to one SalesOrders;
    }


    entity Empl : cuid, managed, Address {
        name  : String;
        email : String;
    }

    aspect Address {
        street : String(100);
        city   : String(100);
        zip    : Integer;
    }

    @cds.search: {
        name,
        employeeId,
        jobTitle,
        status
    }
    entity Employees : cuid, managed {

        employeeId : String(10);
        name       : String(100);
        email      : String(100);

        department : Association to Departments;

        salary     : Decimal(15, 2);

        jobTitle   : String(100);

        status     : String(20);

    }

    entity Departments : cuid {

        departmentId : String(10);
        name         : String(100);

        employees    : Association to many Employees
                           on employees.department = $self;

    }

    entity LeaveRequests : cuid, managed {

        employee  : Association to Employees;

        leaveType : String(50);

        fromDate  : Date;

        toDate    : Date;

        status    : String(30);

        reason    : String(500);

    }


    entity Candidates {
        key CID              : String;
            CNAME            : String;
            CEMAIL           : String;
            CNUMBER          : String;
            CJOB_STATUS      : String;
            CJOB_APPLICATION : String;
            Applied          : Boolean;
    }


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


    entity Managers {

        key MID       : UUID;
        key ID        : UUID;
        key KID       : UUID;
        key SID       : UUID;
            MNAME     : String;

            employees : Composition of many EMPLOYEES22
                            on employees.MANAGER = $self.ID;


    }

    entity EMPLOYEES22 {

        key EMPID   : UUID;
            EMPNAME : String;

            MANAGER : String;


    }


}


// @cds.persistence.exists
// @cds.persistence.table
// entity MDMC {
//     MNAME   : String;
//     TITLE   : String;
//     DESCRIP : String
// }


// @cds.persistence.table
// entity PID_PNUM {
//     key PID     : UUID;
//         PNUMBER : Integer;
// }
