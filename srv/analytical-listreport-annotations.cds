using CatalogService as service from './model_srv';

annotate service.WarehouseStock with @(
    UI.SelectionFields: [
        location,
        product
    ],

    UI.LineItem: [
        { Value: product,      Label: 'Product' },
        { Value: location,     Label: 'Location' },
        { Value: quantity,     Label: 'Quantity on Hand',
          Criticality: stockCriticality },
        { Value: reorderLevel, Label: 'Reorder Level' }
    ],

    UI.Chart #StockByLocation: {
        $Type: 'UI.ChartDefinitionType',
        ChartType: #Bar,

        Dimensions: [
            location
        ],

        DimensionAttributes: [
            {
                Dimension: location,
                Role: #Category
            }
        ],

        Measures: [
            quantity
        ],

        MeasureAttributes: [
            {
                Measure: quantity,
                Role: #Axis1
            }
        ]
    },

    UI.PresentationVariant #StockChartPV: {
        $Type: 'UI.PresentationVariantType',

        Visualizations: [
            '@UI.Chart#StockByLocation'
        ],

        GroupBy: [
            location
        ]
    },

    UI.SelectionPresentationVariant #StockChartSPV: {
        $Type: 'UI.SelectionPresentationVariantType',

        Text: 'Stock by Location',

        PresentationVariant: {
            Visualizations: [
                '@UI.Chart#StockByLocation'
            ]
        }
    }
);