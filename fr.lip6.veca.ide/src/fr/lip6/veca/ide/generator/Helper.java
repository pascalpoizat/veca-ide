package fr.lip6.veca.ide.generator;

public class Helper {
		
	public static boolean underWindows(String name) {
		return name.startsWith("WINDOWS");
	}
	
	public static boolean underOSX(String name) {
		return name.startsWith("MAC OS X");
	}
	
	public static boolean underLinux(String name) {
		return name.startsWith("Linux");
	}

}
