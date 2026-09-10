using CatalogService from './model_srv';


annotate CatalogService.Employees1 with @(

    // =========================================================
    // 1. FILTER BAR
    // =========================================================
    UI.SelectionFields: [
        name,
        department,
        employeeId,
        status
    ],


    // =========================================================
    // 2. LIST REPORT TABLE
    // =========================================================
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: employeeId,
            Label: 'Employee ID'
        },
        {
            $Type: 'UI.DataField',
            Value: name,
            Label: 'EMP NAME'
        },
        {
            $Type: 'UI.DataField',
            Value: email,
            Label: 'Emp Email'
        },
        {
            $Type: 'UI.DataField',
            Value: department,
            Label: 'Department'
        },
        {
            $Type: 'UI.DataField',
            Value: designation,
            Label: 'Designation'
        },
        {
            $Type: 'UI.DataField',
            Value: status,
            Label: 'Status'
        }
    ],


    // =========================================================
    // 3. OBJECT PAGE HEADER
    // =========================================================
    UI.HeaderInfo: {
        TypeName: 'Employee Overview',
        TypeNamePlural: 'Employees',
        Title: {
            $Type: 'UI.DataField',
            Value: name
        },
        Description: {
            $Type: 'UI.DataField',
            Value: designation
        }
    },


    // =========================================================
    // 4. OBJECT PAGE FACETS / SECTIONS
    // =========================================================
    UI.Facets: [

        // Employee Information
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Employee Information',
            Target: '@UI.FieldGroup#EmployeeInfo'
        },

        // Project
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Project Details',
            Target: 'project/@UI.FieldGroup#ProjectDetails'
        },

        // Skills table
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Skills',
            Target: 'skillset/@UI.LineItem'
        },

        // Work Experience table
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Work Experience',
            Target: 'wexp/@UI.LineItem'
        }
    ],


    // =========================================================
    // 5. EMPLOYEE INFORMATION FIELD GROUP
    // =========================================================
    UI.FieldGroup #EmployeeInfo: {
        Data: [

            {
                $Type: 'UI.DataField',
                Label: 'Employee ID',
                Value: employeeId
            },
            {
                $Type: 'UI.DataField',
                Label: 'Employee Name',
                Value: name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Email',
                Value: email
            },
            {
                $Type: 'UI.DataField',
                Label: 'Department',
                Value: department
            },
            {
                $Type: 'UI.DataField',
                Label: 'Designation',
                Value: designation
            },
            {
                $Type: 'UI.DataField',
                Label: 'Salary',
                Value: salary
            },
            {
                $Type: 'UI.DataField',
                Label: 'Status',
                Value: status
            }
        ]
    }

);


annotate CatalogService.ProjectInfo with @(

    // =========================================================
    // 6. PROJECT DETAILS
    // =========================================================
    UI.FieldGroup #ProjectDetails: {
        Data: [

            {
                $Type: 'UI.DataField',
                Label: 'Project Title',
                Value: PTitle
            },
            {
                $Type: 'UI.DataField',
                Label: 'Description',
                Value: PDescription
            },
            {
                $Type: 'UI.DataField',
                Label: 'Project Type',
                Value: PType
            },
            {
                $Type: 'UI.DataField',
                Label: 'Start Date',
                Value: PStartedDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'End Date',
                Value: PEndDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Team Size',
                Value: TeamSize
            }
        ]
    }

);


annotate CatalogService.SkillSet with @(

    // =========================================================
    // 7. SKILL SET TABLE
    // =========================================================
    UI.LineItem: [

        {
            $Type: 'UI.DataField',
            Value: STitle,
            Label: 'Skill'
        },
        {
            $Type: 'UI.DataField',
            Value: Slevel,
            Label: 'Level'
        },
        {
            $Type: 'UI.DataField',
            Value: SDescrip,
            Label: 'Description'
        }
    ]

);


annotate CatalogService.WorkExp with @(

    // =========================================================
    // 8. WORK EXPERIENCE TABLE
    // =========================================================
    UI.LineItem: [

        {
            $Type: 'UI.DataField',
            Value: CompanyName,
            Label: 'Company'
        },
        {
            $Type: 'UI.DataField',
            Value: CompanyType,
            Label: 'Company Type'
        },
        {
            $Type: 'UI.DataField',
            Value: StartDate,
            Label: 'Start Date'
        },
        {
            $Type: 'UI.DataField',
            Value: EndDate,
            Label: 'End Date'
        },
        {
            $Type: 'UI.DataField',
            Value: Exp,
            Label: 'Experience'
        },
        {
            $Type: 'UI.DataField',
            Value: Status,
            Label: 'Current'
        }
    ]

);