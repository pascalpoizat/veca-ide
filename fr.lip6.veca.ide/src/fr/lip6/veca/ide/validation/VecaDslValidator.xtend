/*
 * generated by Xtext 2.13.0
 */
package fr.lip6.veca.ide.validation

import org.eclipse.xtext.validation.Check
import fr.lip6.veca.ide.vecaDsl.VecaDslPackage
import fr.lip6.veca.ide.vecaDsl.Component
import fr.lip6.veca.ide.vecaDsl.IJoinPoint
import fr.lip6.veca.ide.vecaDsl.JoinPoint
import java.util.Arrays
import fr.lip6.veca.ide.vecaDsl.Binding
import fr.lip6.veca.ide.vecaDsl.BindingInformation
import fr.lip6.veca.ide.vecaDsl.EJoinPoint
import fr.lip6.veca.ide.vecaDsl.Operation
import fr.lip6.veca.ide.vecaDsl.Message
import fr.lip6.veca.ide.vecaDsl.CompositeComponent
import fr.lip6.veca.ide.vecaDsl.InternalBinding
import fr.lip6.veca.ide.vecaDsl.ExternalBinding
import fr.lip6.veca.ide.vecaDsl.NamedComponent
import fr.lip6.veca.ide.vecaDsl.Model

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class VecaDslValidator extends AbstractVecaDslValidator {
	
public static val INVALID_NAME = 'invalidName'
public static val UNKNOWN_OPERATION = "unknownOperation"
public static val INCOMPATIBLE_OPERATIONS = "incompatibleOperations"
public static val INCORRECT_BINDING = "incorrectBinding"
public static val INCORRECT_CHILDREN = "incorrectChildren"
public static val INCORRECT_TYPES = "incorrectTypes"
public static val SELF_COMPONENT = "selfComponent"
public static val SELF_BINDING = "selfBinding"
public static val MULTIPLE_BINDINGS_SAME_ID = "multipleBindingsWithSameId"
public static val ERROR = "error"

	// component type names begin with a capital
	@Check
	def checkComponentStartsWithCapital(Component c) {
		if (!Character.isUpperCase(c.name.charAt(0))) {
			warning('Component type name should start with a capital', 
					VecaDslPackage.Literals.COMPONENT__NAME,
					INVALID_NAME,
					c.name)
		}
	}
	
	// all component types have different names
	@Check
	def checkComponentNamesAreDifferent(Model m) {
		for(Component c: m.types) {
			if(m.types.filter[it.name.equals(c.name)].size>1) {
				error(String.format("There is more than one component type named %s", c.name),
					VecaDslPackage.Literals.MODEL__TYPES,
					INCORRECT_TYPES
				)
			}
		}
	}
	
	// bindings relate compatible operations
	// two operations are compatible if:
	// [X] they have the same name
	// [X] they have the same message types
	// [X] for internal bindings connect required to provided (in Component using checkCompatibleOperationsInComponentBindings)
	// [X] for external bindings connect self.provided to provided or required to self.required (in Component using checkCompatibleOperationsInComponentBindings)
 	@Check
	def checkCompatibleOperationsInBinding(BindingInformation b) {
		val o1 = b.point1.findOperation()
		val o2 = b.point2.findOperation()
		if (o1 !== null && o2 !== null) {
			if (!compatible(o1,o2)) {
				error("Incompatible operations (names and/or messages)",
					VecaDslPackage.Literals.BINDING_INFORMATION__POINT1,
					INCOMPATIBLE_OPERATIONS
				)
			}
		}
	}
	
	// bindings in a composite component have different identifiers
	@Check
	def checkBindingIdsAllDifferentInCompositeComponent(CompositeComponent c) {
		for(Binding b: c.bindings) {
			if (c.bindings.filter[it.name==b.name].size > 1) {
				error("Multiple bindings with the same id in a composite component",
					VecaDslPackage.Literals.COMPOSITE_COMPONENT__BINDINGS,
					MULTIPLE_BINDINGS_SAME_ID
				)
			}
		}
	}
	
	// [X] operations used in internal bindings do exist 
 	@Check
	def checkExistingOperationInBinding(BindingInformation b) {
		val p1 = b.point1
		val p2 = b.point2
		for(JoinPoint p : Arrays.asList(p1,p2)) {
			if (p instanceof IJoinPoint) {
				if (!p.checkJoinPoint()) {
					error('''Unknown operation «p.component.name».«p.operation»''', 
						getCause(p,p1,p2),
						UNKNOWN_OPERATION
					)
				}
			}
		}
	}
	
	// no self binding
	@Check
	def checkNoSelfBinding(Binding b) {
		if (b.binfo instanceof InternalBinding) {
			val p1 = b.binfo.point1 as IJoinPoint
			val p2 = b.binfo.point2 as IJoinPoint
			if (p1.component.name.equals(p2.component.name)) {
				error("Self-binding is not allowed",
					VecaDslPackage.Literals.BINDING__BINFO,
					SELF_BINDING
			)
			}
		}
	}

	// [X] internal bindings connect required to provided
	// [X] external bindings connect self.provided to provided or required to self.required
	@Check
	def checkCompatibleOperationsInComponentBindings(CompositeComponent c) {
		for(Binding b: c.bindings) {			
			if (b.binfo instanceof InternalBinding) {
				if (!checkCompatibleOperationsInComponentInternalBinding(c, b.binfo as InternalBinding)) {
					error(String.format("Binding %s is not correct (should be required --> provided)",b.name),
						VecaDslPackage.Literals.COMPOSITE_COMPONENT__BINDINGS,
						INCORRECT_BINDING
					)				
				}
			}	
			else if (b.binfo instanceof ExternalBinding) {
				if (!checkCompatibleOperationsInComponentExternalBinding(c, b.binfo as ExternalBinding)) {
					error(String.format("Binding %s is not correct (should be self.provided ==> provided or required ==> self.required)",b.name),
						VecaDslPackage.Literals.COMPOSITE_COMPONENT__BINDINGS,
						INCORRECT_BINDING
					)						
				}
			}
		}
	}
	
	// children in composites have different names
	@Check
	def checkChildrenHaveDifferentNames(CompositeComponent c) {
		for(NamedComponent sc: c.children)
			if(c.children.filter[it.name.equals(sc.name)].size>1) {
				error(String.format("There is more than one subcomponent named %s",sc.name),
					VecaDslPackage.Literals.COMPOSITE_COMPONENT__CHILDREN,
					INCORRECT_CHILDREN
				)
			}
	}
	
	// helpers
	
	def equals(Message m1, Message m2) {
		if (m1===null || m2===null)
			return m1===m2
		return m1.name.equals(m2.name)
	}
	
	def compatible(Operation o1, Operation o2) {
		return
			o1.name.equals(o2.name) &&
			equals(o1.inputMessage, o2.inputMessage) &&
			equals(o1.outputMessage, o2.outputMessage)
	}

	def findOperation(JoinPoint p) {	
		if (p instanceof EJoinPoint) {
			return p.operation
		}
		else {
			// can be null
			return (p as IJoinPoint).component.type.findOperation((p as IJoinPoint).operation)
		}	
	}
		
	def getCause(JoinPoint p, JoinPoint p1, JoinPoint p2) {
		if (p===p1)
			return VecaDslPackage.Literals.BINDING_INFORMATION__POINT1
		else
			return VecaDslPackage.Literals.BINDING_INFORMATION__POINT2
	}
	
	def checkJoinPoint(IJoinPoint p) {
		// p is x.o, we have to check there is an operation o in x
		return p.component.type.hasOperation(p.operation)
	}
	
	def hasOperation(Component c, String oname) {
		return isProvidedOperation(c,oname) || isRequiredOperation(c,oname)
	}
	
	def findOperation(Component c, String oname) {
		var o = c.signature.providedOps?.findFirst[it.name.equals(oname)]
		if (o === null) {
			o = c.signature.requiredOps?.findFirst[it.name.equals(oname)]
		}
		return o
	}
	
	def isProvidedOperation(Component c, String oname) {
		if(c.signature.providedOps !== null)
			return c.signature.providedOps.exists[it.name.equals(oname)]
		return false
	}
	
	def isRequiredOperation(Component c, String oname) {
		if(c.signature.requiredOps !== null)
			return c.signature.requiredOps.exists[it.name.equals(oname)]
		return false
	}
	
	// an internal binding c1.o1 --> c2.o2 is ok if o1 is required by c1 and o2 is provided by c2
	// note that for full correctness, we also have to use checkCompatibleOperationsInBinding (checks op names and messages)
	def checkCompatibleOperationsInComponentInternalBinding(CompositeComponent c, InternalBinding b) {
		val o1 = (b.point1 as IJoinPoint).operation
		val o2 = (b.point2 as IJoinPoint).operation
		val c1 = (b.point1 as IJoinPoint).component.type
		val c2 = (b.point2 as IJoinPoint).component.type
		return (isRequiredOperation(c1,o1) && isProvidedOperation(c2,o2))			
	}

	// an external binding c1.o1 ==> c2.o2 is ok if
	// - either o1 is provided by c1 and o2 is provided by c2 and c1 is self
	// - or o1 is required by c1 and o2 is required by c2 and c2 is self
	// note that for full correctness, we also have to use checkCompatibleOperationsInBinding (checks op names and messages)
	def checkCompatibleOperationsInComponentExternalBinding(CompositeComponent c, ExternalBinding b) {
		if (b.point1 instanceof EJoinPoint && b.point2 instanceof IJoinPoint) { // self.o1 ==> c2.o2
			val o1 = (b.point1 as EJoinPoint).operation.name
			val o2 = (b.point2 as IJoinPoint).operation
			val c1 = c
			val c2 = (b.point2 as IJoinPoint).component.type
			return (isProvidedOperation(c1,o1) && isProvidedOperation(c2,o2))
		}		
		else if (b.point1 instanceof IJoinPoint && b.point2 instanceof EJoinPoint) { // c1.o1 ==> self.o2
			val o1 = (b.point1 as IJoinPoint).operation
			val o2 = (b.point2 as EJoinPoint).operation.name
			val c1 = (b.point1 as IJoinPoint).component.type
			val c2 = c
			return (isRequiredOperation(c1,o1) && isRequiredOperation(c2,o2))	
		}
		else // not possible wrt the grammar
			return false
	}
	
}
