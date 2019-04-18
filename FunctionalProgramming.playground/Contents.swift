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

// ## High order functions (first-class) ##
// filter
let apples = ["🍎", "🍏", "🍎", "🍏", "🍏"]
let greenapples = apples.filter { $0 == "🍏"}
print(greenapples)

// using filter to filter out rides
func waitTimeIsShort(_ ride: Ride) -> Bool {
    return ride.waitTime < 15.0
}

let shortWaitTimeRides = parkRides.filter(waitTimeIsShort)
print("rides with a short wait time: \n\(shortWaitTimeRides)")

// passing a trailing closure
let shortWaitTimeRides2 = parkRides.filter { $0.waitTime < 15.0 }
print(shortWaitTimeRides2)

// map
let oranges = apples.map { _ in "🍊" }
print(oranges)

let rideNames = parkRides.map {$0.name}
print(rideNames)
testOriginalNameOrder(rideNames)
print(rideNames.sorted(by: <))

func sortedNamesFP(_ rides: [Ride]) -> [String] {
    let rideNames = parkRides.map { $0.name }
    return rideNames.sorted(by: <)
}

let sortedNames2 = sortedNamesFP(parkRides)
testSortedNames(sortedNames2)

// reduce
let juice = oranges.reduce("") { juice, orange in juice + "🍹"}
print("fresh 🍊 juice is served – \(juice)")

let totalWaitTime = parkRides.reduce(0.0) { (total, ride) in
    total + ride.waitTime
}
print("total wait time for all rides = \(totalWaitTime) minutes")

// ## Advanced Techniques ##
// partial functions - encapsulate one function within another
func filter(for category: RideCategory) -> ([Ride]) -> [Ride] {
    return { rides in
        rides.filter { $0.categories.contains(category) }
    }
}

let kidRideFilter = filter(for: .kids)
print("some good rides for kids are:\n\(kidRideFilter(parkRides))")

// pure functions
// - always produces same output when given same input
// - creates zero side effects outside of it
func ridesWithWaitTimeUnder(_ waitTime: Minutes,
                            from rides: [Ride]) -> [Ride] {
    return rides.filter { $0.waitTime < waitTime}
}

let shortWaitRides = ridesWithWaitTimeUnder(15, from: parkRides)

// easy to write good unit test against pure functions
func testShortWaitRides(_ testFilter:(Minutes, [Ride]) -> [Ride]) {
    let limit = Minutes(15)
    let result = testFilter(limit, parkRides)
    print("rides with wait less than 15 minutes:\n\(result)")
    let names = result.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse",
                    "Mountain Railroad"]
    assert(names == expected)
    print("✅ test rides with wait time under 15 = PASS\n-")
}

testShortWaitRides(ridesWithWaitTimeUnder(_:from:))

// referential transparency
testShortWaitRides({ waitTime, rides in
    return rides.filter { $0.waitTime < waitTime}
})

// recursion
// operator overloading to create functions that allow you to compare two rides
extension Ride: Comparable {
    public static func  <(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.waitTime < rhs.waitTime
    }
    
    public static func ==(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Array where Element: Comparable {
    func quickSorted() -> [Element] {
        if self.count > 1 {
            let (pivot, remaining) = (self[0], dropFirst())
            let lhs = remaining.filter { $0 <= pivot }
            let rhs = remaining.filter { $0 > pivot }
            return lhs.quickSorted() + [pivot] + rhs.quickSorted()
        }
        return self
    }
}

let quickSortedRides = parkRides.quickSorted()
print("\(quickSortedRides)")


func testSortedByWaitRides(_ rides: [Ride]) {
    let expected = rides.sorted(by:  { $0.waitTime < $1.waitTime })
    assert(rides == expected, "unexpected order")
    print("✅ test sorted by wait time = PASS\n-")
}

testSortedByWaitRides(quickSortedRides)

// ## Imperative vs Declarative Style ##

/*
 Situation
 A family with young kids wants to go on as many rides as possible between frequent bathroom breaks. They need to find which kid-friendly rides have the shortest lines. Help them out by finding all family rides with wait times less than 20 minutes and sort them by the shortest to longest wait time.
*/

// Imperative approach
var ridesOfInterest: [Ride] = []
for ride in parkRides where ride.waitTime < 20 {
    for category in ride.categories where category == .family {
        ridesOfInterest.append(ride)
        break
    }
}

let sortedRidesOfInterest1 = ridesOfInterest.quickSorted()
print(sortedRidesOfInterest1)

// Imperative test
func testSortedRidesOfInterest(_ rides: [Ride]) {
    let names = rides.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse",
                    "Grand Carousel",
                    "Mountain Railroad"]
    assert(names == expected)
    print("✅ test rides of interest = PASS\n-")
}

testSortedRidesOfInterest(sortedRidesOfInterest1)

// Functional approach
let sortedRidesOfInterest2 = parkRides
    .filter { $0.categories.contains(.family) && $0.waitTime < 20 }
    .sorted(by: <)

// Functional test
testSortedRidesOfInterest(sortedRidesOfInterest2)

