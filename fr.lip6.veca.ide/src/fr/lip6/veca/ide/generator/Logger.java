package fr.lip6.veca.ide.generator;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.time.LocalDateTime;

// a simple logger
// because making an Eclipse plugin work with log4j and write in the console seem quite complicated ...
public class Logger {
	
	private static final String INFO_REPR = "> INFO: %s";
	private static final String WARNING_REPR = "> WARNING: %s";
	private static final String ERROR_REPR = "> ERROR: %s";
	private static final String DATETIME_REPR = "%s";
	
	private StringBuilder log;
	
	public Logger() {
		log = new StringBuilder();
	}
	
	public void reset() {
		log = new StringBuilder();
	}
	
	public void append(String repr, String msg, boolean withDateTime) {
		if (withDateTime)
			log.append(String.format(DATETIME_REPR + repr + "\n", LocalDateTime.now(), msg));
		else
			log.append(String.format(repr +"\n",  msg));
	}
	
	public void append(String repr, InputStream stream, boolean withDateTime) {
		append(repr, "", withDateTime);
		BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
		String line = "";
		try {
			while((line = reader.readLine()) != null)
				append("\t%s", line, false);
		} catch (IOException e) {
			error(e.toString(), true);
		}
	}
	
	public void info(String msg, boolean withDateTime) {
		this.append(INFO_REPR, msg, withDateTime);
	}

	public void warning(String msg, boolean withDateTime) {
		this.append(WARNING_REPR, msg, withDateTime);
	}

	public void error(String msg, boolean withDateTime) {
		this.append(ERROR_REPR, msg, withDateTime);
	}
	
	public void info(InputStream stream, boolean withDateTime) {
		this.append(INFO_REPR, stream, withDateTime);
	}

	public void warning(InputStream stream, boolean withDateTime) {
		this.append(WARNING_REPR, stream, withDateTime);
	}

	public void error(InputStream stream, boolean withDateTime) {
		this.append(ERROR_REPR, stream, withDateTime);
	}
	
	@Override
	public String toString() {
		return log.toString();
	}

}
