package fr.lip6.veca.ide.generator;

import fr.lip6.veca.ide.vecaDsl.Action;

public class GenTransition {
	public GenState source;
	public GenState target;
	public Action label;
	public GenTransition(GenState source, Action label, GenState target) {
		this.source = source;
		this.label = label;
		this.target = target;
	}
}
