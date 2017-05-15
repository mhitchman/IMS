// These are here to make it really easy to change the port globablly across the whole system
// The port only needs to be set in one place and then changed in that one place and since it is a static variable all instances of OscHelper will share it

public class OscHelper{
	static int oscPort;
}