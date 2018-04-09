package fr.lip6.veca.ide.generator;

import fr.lip6.veca.ide.vecaDsl.Action;
import fr.lip6.veca.ide.vecaDsl.CommunicationAction;
import fr.lip6.veca.ide.vecaDsl.InternalAction;
import fr.lip6.veca.ide.vecaDsl.Operation;

public class GenAction {
	public Action action;
	public GenAction(Action action) {
		this.action = action;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((action == null) ? 0 : genHashCode(result,prime));
		return result;
	}

	private int genHashCode(int result, int prime) {
		String code = null;
		Operation op = null;
		if (action instanceof InternalAction)
			code = "CTau";
		else {
			op = ((CommunicationAction)action).getOperation();
			switch (((CommunicationAction)action).getCommunicationKind()) {
			case RECEIVE:
				code = "CReceive";
				break;
			case REPLY:
				code = "CReply";
				break;
			case INVOKE:
				code = "CInvoke";
				break;
			case RESULT:
				code = "CResult";
				break;
			default:
				break;
			}
		}
		result = prime * result + ((code == null) ? 0 : code.hashCode());
		result = prime * result + ((op == null) ? 0 : op.getName().hashCode());
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
		GenAction other = (GenAction) obj;
		if (action == null) {
			if (other.action != null)
				return false;
			else
				return true; // both have null actions
		} else { // both have non null actions
			if (action.getClass() != other.action.getClass())
				return false;
			if (action instanceof CommunicationAction) {
				CommunicationAction a1 = (CommunicationAction) action;
				CommunicationAction a2 = (CommunicationAction) other.action;
				if (!a1.getCommunicationKind().equals(a2.getCommunicationKind()))
					return false;
				if (!a1.getOperation().getName().equals(a2.getOperation().getName()))
					return false;
				// else same communication kind and same operation (because same name), so true
			}
			// else both this and obj are encapsulating internal actions, so true
		}
		return true;
	}

}
