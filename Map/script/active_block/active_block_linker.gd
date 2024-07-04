class_name ActiveBlockLinker
extends PinJoint2D

func _init(phy_nodeA: PhysicsBody2D, phy_nodeB: PhysicsBody2D):
	node_a = phy_nodeA.get_path()
	node_b = phy_nodeB.get_path()
