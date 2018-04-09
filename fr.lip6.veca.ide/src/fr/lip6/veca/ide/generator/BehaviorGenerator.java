package fr.lip6.veca.ide.generator;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import fr.lip6.veca.ide.vecaDsl.Behavior;
import fr.lip6.veca.ide.vecaDsl.Transition;
import fr.lip6.veca.ide.vecaDsl.TransitionAction;

public class BehaviorGenerator {
	
	private static BehaviorGenerator _instance = new BehaviorGenerator();
	
	private BehaviorGenerator() {}
	
	public static BehaviorGenerator instance() {
		return _instance;
	}
	
	public Set<GenAction> computeAlphabet(Behavior b) {
		Set<GenAction> alphabet = new HashSet<>();
		for(Transition t: b.getTransitions()) {
			for(TransitionAction ta : t.getActions()) {
				alphabet.add(new GenAction(ta.getAction()));
			}
		}
		return alphabet;		
	}
	
	public Set<GenState> computeStates(Behavior b) {
		Set<GenState> states = new HashSet<>();
		for(Transition t : b.getTransitions()) {
			states.add(new GenState(t.getSource()));
			for(TransitionAction ta : t.getActions()) {
				states.add(new GenState(ta.getTarget()));
			}
		}
		return states;
	}
	
	public List<GenTransition> computeTransitions(Behavior b) {
		List<GenTransition> transitions = new ArrayList<>();
		for(Transition t : b.getTransitions()) {
			for(TransitionAction ta : t.getActions()) {
				transitions.add(new GenTransition(new GenState(t.getSource()), ta.getAction(), new GenState(ta.getTarget())));
			}
		}
		return transitions;
	}
	
}
