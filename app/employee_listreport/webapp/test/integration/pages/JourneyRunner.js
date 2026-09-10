sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"employeelistreport/test/integration/pages/Employees1List.gen",
	"employeelistreport/test/integration/pages/Employees1ObjectPage.gen"
], function (JourneyRunner, Employees1ListGenerated, Employees1ObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('employeelistreport') + '/test/flp.html#app-preview',
        pages: {
			onTheEmployees1ListGenerated: Employees1ListGenerated,
			onTheEmployees1ObjectPageGenerated: Employees1ObjectPageGenerated
        },
        async: true
    });

    return runner;
});

