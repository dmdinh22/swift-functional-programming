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
