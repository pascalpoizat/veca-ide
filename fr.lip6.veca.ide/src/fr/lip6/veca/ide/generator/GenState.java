package fr.lip6.veca.ide.generator;

import fr.lip6.veca.ide.vecaDsl.State;

public class GenState {
	public State state;
	
	public GenState(State state) {
		this.state = state;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((state == null) ? 0 : state.getName().hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		GenState other = (GenState) obj;
		if (state == null) {
			if (other.state != null)
				return false;
		} else if (!state.getName().equals(other.state.getName()))
			return false;
		return true;
	}
}
