import Foundation

var thing = 3
// some stuff
thing = 4

// Immutability & Side Effects
func superHero() {
    print("I'm batman")
    thing = 5 // side effect
}

print("original state = \(thing)")
superHero()
print("mutated state = \(thing)")

// Model Amusement Park
enum RideCategory: String, CustomStringConvertible {
    case family
    case kids
    case thrill
    case scary
    case relaxing
    case water
    
    var description: String {
        return rawValue
    }
}

typealias Minutes = Double

struct Ride: CustomStringConvertible {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes
    
    var description: String {
        return "Ride –\"\(name)\", wait: \(waitTime) mins, " +
        "categories: \(categories)\n"
    }
}

let parkRides = [
    Ride(name: "Raging Rapids",
         categories: [.family, .thrill, .water],
         waitTime: 45.0),
    Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
    Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
    Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
    Ride(name: "Thunder Coaster",
         categories: [.family, .thrill],
         waitTime: 60.0),
    Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
    Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
    Ride(name: "Mountain Railroad",
         categories: [.family, .relaxing],
         waitTime: 0.0)
]

// ## Modularity ##
func sortedNamesImp(of rides: [Ride]) -> [String] {
    
    // 1 - create var
    var sortedRides = rides
    var key: Ride
    
    // 2 - spin through rides passed in
    for i in (0..<sortedRides.count) {
        key = sortedRides[i]
        
        // 3 - sort rides using Insertion Sort algo
        for j in stride(from: i, to: -1, by: -1) {
            if key.name.localizedCompare(sortedRides[j].name) == .orderedAscending {
                sortedRides.remove(at: j + 1)
                sortedRides.insert(key, at: j)
            }
        }
    }
    
    // 4 - spin through sorted rides to gather names
    var sortedNames: [String] = []
    for ride in sortedRides {
        sortedNames.append(ride.name)
    }
    
    return sortedNames
}

// alphabetical sort
let sortedNames1 = sortedNamesImp(of: parkRides)

func testSortedNames(_ names: [String]) {
    let expected = ["Bumper Boats",
                    "Crazy Funhouse",
                    "Grand Carousel",
                    "Mountain Railroad",
                    "Raging Rapids",
                    "Spinning Tea Cups",
                    "Spooky Hollow",
                    "Thunder Coaster"]
    assert(names == expected)
    print("✅ test sorted names = PASS\n-")
}

print(sortedNames1)
testSortedNames(sortedNames1)

// test original list was not mutated
var originalNames: [String] = []
for ride in parkRides {
    originalNames.append(ride.name)
}

func testOriginalNameOrder(_ names: [String]) {
    let expected = ["Raging Rapids",
                    "Crazy Funhouse",
                    "Spinning Tea Cups",
                    "Spooky Hollow",
                    "Thunder Coaster",
                    "Grand Carousel",
                    "Bumper Boats",
                    "Mountain Railroad"]
    assert(names == expected)
    print("✅ test original name order = PASS\n-")
}

print(originalNames)
testOriginalNameOrder(originalNames)
