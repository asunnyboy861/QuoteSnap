import Foundation

struct TemplateService {
    static let presetItems: [TemplateType: [(String, String, Double)]] = [
        .landscaping: [
            ("Lawn Mowing", "lot", 45),
            ("Hedge Trimming", "hr", 55),
            ("Mulching", "sq ft", 0.75),
            ("Garden Bed Cleanup", "lot", 85),
            ("Tree Pruning", "hr", 75),
            ("Leaf Removal", "lot", 65),
            ("Fertilizer Application", "lot", 50),
            ("Sod Installation", "sq ft", 1.50),
        ],
        .cleaning: [
            ("Deep Clean", "lot", 200),
            ("Regular Clean", "lot", 120),
            ("Move-Out Clean", "lot", 250),
            ("Window Cleaning", "each", 15),
            ("Carpet Cleaning", "room", 75),
            ("Pressure Washing", "sq ft", 0.35),
            ("Post-Construction Clean", "lot", 350),
        ],
        .plumbing: [
            ("Pipe Repair", "hr", 95),
            ("Faucet Installation", "each", 150),
            ("Toilet Repair", "each", 120),
            ("Water Heater Service", "each", 200),
            ("Drain Cleaning", "each", 150),
            ("Emergency Call-Out", "lot", 175),
            ("Leak Detection", "lot", 150),
            ("Sewer Line Repair", "hr", 125),
        ],
        .electrical: [
            ("Wiring Installation", "hr", 85),
            ("Panel Upgrade", "lot", 1200),
            ("Outlet Installation", "each", 125),
            ("Light Fixture Install", "each", 100),
            ("Circuit Breaker Replace", "each", 150),
            ("Ceiling Fan Install", "each", 125),
            ("GFCI Outlet", "each", 135),
            ("Inspection Service", "lot", 200),
        ],
        .handyman: [
            ("Drywall Repair", "lot", 150),
            ("Painting", "room", 200),
            ("Door Installation", "each", 175),
            ("Furniture Assembly", "hr", 60),
            ("Fence Repair", "hr", 65),
            ("Gutter Cleaning", "lot", 125),
            ("Deck Repair", "sq ft", 15),
            ("General Fix", "hr", 55),
        ],
        .hvac: [
            ("AC Repair", "lot", 200),
            ("Furnace Service", "lot", 175),
            ("Duct Cleaning", "lot", 300),
            ("Thermostat Install", "each", 150),
            ("Filter Replacement", "each", 25),
            ("System Inspection", "lot", 100),
            ("Refrigerant Recharge", "lot", 250),
            ("Emergency Service", "lot", 225),
        ],
        .painting: [
            ("Interior Painting", "room", 350),
            ("Exterior Painting", "sq ft", 2.50),
            ("Cabinet Refinishing", "lot", 800),
            ("Trim Painting", "sq ft", 1.50),
            ("Wall Preparation", "lot", 150),
            ("Primer Application", "sq ft", 1.00),
            ("Accent Wall", "wall", 200),
            ("Ceiling Painting", "room", 250),
        ],
        .general: []
    ]

    static func getPresetItems(for template: TemplateType) -> [LineItem] {
        let items = presetItems[template] ?? []
        return items.map { desc, unit, price in
            LineItem(description: desc, quantity: 1, unit: unit, unitPrice: price, total: price)
        }
    }

    static let templateIcons: [TemplateType: String] = [
        .landscaping: "leaf.fill",
        .cleaning: "spraybottle.fill",
        .plumbing: "wrench.and.screwdriver.fill",
        .electrical: "bolt.fill",
        .handyman: "hammer.fill",
        .hvac: "fanblades.fill",
        .painting: "paintbrush.fill",
        .general: "doc.fill"
    ]

    static let templateColors: [TemplateType: String] = [
        .landscaping: "38BA59",
        .cleaning: "2E9E8A",
        .plumbing: "1270C4",
        .electrical: "FF9C1E",
        .handyman: "8B5CF6",
        .hvac: "3B82F6",
        .painting: "EC4899",
        .general: "6B7280"
    ]
}
