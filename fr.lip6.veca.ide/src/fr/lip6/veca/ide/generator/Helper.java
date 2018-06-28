package fr.lip6.veca.ide.generator;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class Helper {
	
	public static final void execute(List<String> partList, Logger log) {
		try {
			log.info(String.format("command is %s.", partList.stream().collect(Collectors.joining(" "))), true);
			String[] parts = (String[]) partList.toArray();
			Process process = Runtime.getRuntime().exec(parts);
			process.waitFor();
			if (process.exitValue() == 0)
				log.info(process.getInputStream(), false);
			else
				log.error(process.getErrorStream(), false);
		}
		catch (IOException | InterruptedException e) {
			log.error(e.toString(), true);
		}		
	}
	
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
