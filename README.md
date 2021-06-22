# iORA

The MoleculeDemo4 Xcode project contains almost all the functionality that should go into the final app. The code there is pretty cluttered and is prone to frequent crashes. It also has a few too many buttons. 

The iORA Xcode project is a new project I started to take just the good code, clean it up, and put it into a new project. It's still missing a lot of the functionality from MoleculeDemo4, including the following: 
  - Working buttons
  - Highlight tapped atoms 
  - Dynamically change radius size 
  
Features that haven't been coded at all yet include the following: 
  - Tapping a bond will give information about the 2 atoms it connects
  - Dihedral angles when selecting 4 atoms (I haven't had the courage to face that nasty algorithm yet) 
  - The algorithm for calculating when atoms should bond is close but still makes extra bonds when it shouldn't at times. 
  
  
  
  
BONDING ALGORITHM

The bonding algorithm currently works as follows: 
   for atom1 in atoms:
    for atom2 in atoms:
        calculateDistance
        if distance < 0.8:
            add to dictionary
    sort dictionary
    for i in atom1.getMaxBonds:
        bond atom1 to atom2


The problem with this algorithm is it will sometimes bond an atom with extra bonds it can make to an atom that already has enough bonds. What needs to happen there is to have some way to attach the number of other atoms it's currently bonded to onto the SCNNode object. I haven't found a way to elegantly do that. One of the changes I tried to make between MoleculeDemo4 and iORA was to decrease the number of different objects that were created. MoleculeDemo4 had a list of SCNNode and custom "Atom" objects that held information about the atoms. This was a bit cumbersome and made sorting the atoms really difficult. I've tried to avoid that here by using dictionaries with an SCNNode as the key and information about the atom as the value. I think you could even use the same Atom object and give it numberPossibleBonds and numberBonds attributes...

My idea for this would be to sort the atoms first by the number of bonds they can make. Those atoms that have the smallest number should bond first, then move up, so that the atoms with more potential bonds don't "steal" potential bonds from other atoms.

----UPDATE JUNE 2021----

The plan going forward is to abandon the current bonding algorithm in favor of integrating several of OpenBabel's open source libraries into the project. This should hopefully clear up several of the issues that the current bonding algorithm has. 
