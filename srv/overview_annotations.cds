using CatalogService as service from './model_srv';

annotate service.Employees with @(

UI.LineItem: [
  {
    Value: employeeId,
    Label: 'Employee ID'
  },
  {
    Value: name,
    Label: 'Name'
  },
  {
    Value: jobTitle,
    Label: 'Designation'
  },
  {
    Value: status,
    Label: 'Status'
  }
]);


annotate service.LeaveRequests with @(UI.LineItem: [
  {
    Value: employee.name,
    Label: 'Employee'
  },
  {
    Value: leaveType,
    Label: 'Leave Type'
  },
  {
    Value: fromDate,
    Label: 'From'
  },
  {
    Value: toDate,
    Label: 'To'
  },
  {
    Value: status,
    Label: 'Status'
  }
]);

annotate service.Departments with @(UI.LineItem: [
  {
    Value: departmentId,
    Label: 'Dept ID'
  },
  {
    Value: name,
    Label: 'Department'
  }
]);
annotate service.EmployeesByStatus with @(
  Analytics.query: true,
  UI.Chart: {
    ChartType: #Donut,
    Dimensions: [status],
    DimensionAttributes: [{ Dimension: status, Role: #Category }],
    Measures: [employeeCount],
    MeasureAttributes: [{ Measure: employeeCount, Role: #Axis1 }]
  },
  UI.PresentationVariant: {
    Visualizations: ['@UI.Chart'],
    GroupBy: [status]
  }
);


annotate service.EmployeesByDepartment with @(
  Analytics.query: true,
  UI.Chart: {
    ChartType: #Bar,
    Dimensions: [department],
    DimensionAttributes: [{ Dimension: department, Role: #Category }],
    Measures: [employeeCount],
    MeasureAttributes: [{ Measure: employeeCount, Role: #Axis1 }]
  },
  UI.PresentationVariant: { Visualizations: ['@UI.Chart'], GroupBy: [department] }
);

annotate service.LeaveRequestsByMonth with @(
  Analytics.query: true,
  UI.Chart: {
    ChartType: #Line,
    Dimensions: [month],
    DimensionAttributes: [{ Dimension: month, Role: #Category }],
    Measures: [leaveCount],
    MeasureAttributes: [{ Measure: leaveCount, Role: #Axis1 }]
  },
  UI.PresentationVariant: { Visualizations: ['@UI.Chart'], GroupBy: [month] }
);

annotate service.DepartmentAttrition with @(
  Analytics.query: true,
  UI.Chart: {
    ChartType: #Combination,
    Dimensions: [department],
    DimensionAttributes: [{ Dimension: department, Role: #Category }],
    Measures: [headcount, attritionRate],
    MeasureAttributes: [
      { Measure: headcount, Role: #Axis1 },
      { Measure: attritionRate, Role: #Axis2 }
    ]
  },
  UI.PresentationVariant: { Visualizations: ['@UI.Chart'], GroupBy: [department] }
);
annotate service.EmployeeSalaryTenure with @(
  Analytics.query: true,
  UI.Chart: {
    ChartType: #Scatter,
    Dimensions: [name],
    DimensionAttributes: [{ Dimension: name, Role: #Category }],
    Measures: [salary, tenureYears],
    MeasureAttributes: [
      { Measure: salary, Role: #Axis1 },
      { Measure: tenureYears, Role: #Axis2 }
    ]
  },
  UI.PresentationVariant: { Visualizations: ['@UI.Chart'] }
);

annotate service.LeaveTypeByDepartment with @(
  Analytics.query: true,
  UI.Chart: {
    ChartType: #Heatmap,
    Dimensions: [leaveType, department],
    DimensionAttributes: [
      { Dimension: leaveType, Role: #Category },
      { Dimension: department, Role: #Category2 }
    ],
    Measures: [leaveCount],
    MeasureAttributes: [{ Measure: leaveCount, Role: #Axis1 }]
  },
  UI.PresentationVariant: { Visualizations: ['@UI.Chart'], GroupBy: [leaveType, department] }
);