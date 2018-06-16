/*
 * generated by Xtext 2.13.0
 */
package fr.lip6.veca.ide.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import fr.lip6.veca.ide.vecaDsl.Model
import fr.lip6.veca.ide.vecaDsl.BasicComponent
import fr.lip6.veca.ide.vecaDsl.CompositeComponent
import fr.lip6.veca.ide.vecaDsl.Component
import fr.lip6.veca.ide.vecaDsl.Signature
import fr.lip6.veca.ide.vecaDsl.Operation
import fr.lip6.veca.ide.vecaDsl.Message
import fr.lip6.veca.ide.vecaDsl.NamedComponent
import fr.lip6.veca.ide.vecaDsl.Behavior
import fr.lip6.veca.ide.vecaDsl.TimeConstraint
import fr.lip6.veca.ide.vecaDsl.InternalBinding
import fr.lip6.veca.ide.vecaDsl.ExternalBinding
import fr.lip6.veca.ide.vecaDsl.CommunicationAction
import fr.lip6.veca.ide.vecaDsl.CommunicationKind
import fr.lip6.veca.ide.vecaDsl.Binding
import fr.lip6.veca.ide.vecaDsl.JoinPoint
import fr.lip6.veca.ide.vecaDsl.EJoinPoint
import fr.lip6.veca.ide.vecaDsl.IJoinPoint
import fr.lip6.veca.ide.vecaDsl.State
import fr.lip6.veca.ide.vecaDsl.InternalAction
import fr.lip6.veca.ide.vecaDsl.Action
import java.time.LocalDateTime

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class VecaDslGenerator extends AbstractGenerator {
	
	public static final String JSON_FILE_EXTENSION = "json"
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val model = resource.allContents.filter(Model).toList.get(0)
		val inputURI = resource.URI
		val outputURI = inputURI.trimFileExtension.appendFileExtension(JSON_FILE_EXTENSION)
		var contents = new StringBuilder
		contents.append("// VECA to JSON transformation\n")
		contents.append(String.format("// input file: %s\n", inputURI))
		contents.append(String.format("// output file: model.json (should be %s)\n", outputURI))
		contents.append(String.format("// generated on: %s\n", LocalDateTime.now))
		contents.append(doGenerate(model))
		fsa.generateFile("model.json", contents.toString)
	}
	
	def doGenerate(Model m) '''
	«doGenerate(m.root)»
	'''

	def doGenerate(Component c) {
		if(c instanceof BasicComponent)
			doGenerate(c as BasicComponent)
		else if(c instanceof CompositeComponent) {
			doGenerate(c as CompositeComponent)
		}
		else ''''''
	}
	
	def doGenerate(BasicComponent c) '''
	{
		"componentId": ["«c.name»"],
		"tag": "BasicComponent",
		"signature": «doGenerate(c.signature)»,
		"behavior": «doGenerate(c.behavior)»,
		"timeconstraints": [
			«c.constraints.map[doGenerate].join(",")»
		]
	}
	'''
	
	def doGenerate(CompositeComponent c) {
		var inbinds = c.bindings.filter[it.binfo instanceof InternalBinding]
		var extbinds = c.bindings.filter[it.binfo instanceof ExternalBinding]
	'''
	{
		"componentId": ["«c.name»"],
		"tag": "CompositeComponent",
		"signature": «doGenerate(c.signature)»,
		"children": [
			«c.children.map[doGenerate].join(",")»
		],
		"inbinds": [
			«inbinds.map[doGenerate].join(",")»
		],
		"extbinds": [
			«extbinds.map[doGenerate].join(",")»
		]
	}
	'''
	}
	
	def doGenerate(Signature s) {
		var ops = s.providedOps
		ops.addAll(s.requiredOps)
	'''
	{
		"providedOperations": [«s.providedOps.map[doGenerate].join(",")»],
		"requiredOperations": [«s.requiredOps.map[doGenerate].join(",")»],
		"input": [
			«ops.map[doGenerateInput].join(",")»
		],
		"output": [
			«ops.map[doGenerateOutput].join(",")»
		]
	}
	'''
	}
	
	def doGenerate(Operation o) '''["«o.name»"]'''
	
	def doGenerateInput(Operation o) '''
	[
		«doGenerate(o)»,
		«doGenerate(o.inputMessage)»
	]
	'''
	
	def doGenerateOutput(Operation o) '''
	[
		«doGenerate(o)»,
		«IF o.outputMessage === null»
		null
		«ELSE»
		«doGenerate(o.outputMessage)»
		«ENDIF»
	]
	'''
	
	def doGenerate(Message m) '''
	{
		"messagename": ["«m.name»"],
		"messagetype": ""
	}
	'''
	
	def doGenerate(NamedComponent n) '''
	{
		"instanceId": ["«n.name»"],
		"componentType": «doGenerate(n.type)»
	}
	'''
	
	def doGenerate(Behavior b) {
		val alphabet = BehaviorGenerator.instance.computeAlphabet(b)
		val states = BehaviorGenerator.instance.computeStates(b)
		val transitions = BehaviorGenerator.instance.computeTransitions(b)
	'''
	{
		"alphabet": [«alphabet.map[doGenerate].join(",")»],
		"states": [«states.map[doGenerate].join(",")»],
		"initialState": «doGenerate(b.initialState)»,
		"finalStates": [«b.finalStates.map[doGenerate].join(",")»],
		"transitions": [«transitions.map[doGenerate].join(",")»]
	}
	'''	
	}
	
	def doGenerate(GenState s) '''"«s.state.name»"'''
	
	def doGenerate(State s) '''"«s.name»"'''
	
	def doGenerate(GenTransition t) '''
	{
		"source": «doGenerate(t.source)»,
		"target": «doGenerate(t.target)»,
		"label": «doGenerate(t.label)»
	}
	'''
	
	def doGenerate(Action a) {
		if(a instanceof CommunicationAction) {
			return doGenerate(a as CommunicationAction)	
		}
		else if (a instanceof InternalAction) {
			return doGenerate(a as InternalAction)
		}
		else {
			return ""
		}
	}
	
	def doGenerate(GenAction a) {
		return doGenerate(a.action);
	}
	
	def doGenerate(TimeConstraint c) '''
	{
		"startEvent": «doGenerate(c.e1)»,
		"stopEvent": «doGenerate(c.e2)»,
		"beginTime": «c.d1»,
		"endTime": «c.d2»
	}
	'''
	
	def doGenerate(InternalAction a) '''
	{
		"tag": "CTau"
	}
	'''
	
	def doGenerate(CommunicationAction e) '''
	{
		"tag": "«doGenerate(e.communicationKind)»",
		"contents": «doGenerate(e.operation)»
	}
	'''
	
	def doGenerate(CommunicationKind k) {
		switch k {
			case RECEIVE: "CReceive"
			case REPLY: "CReply"
			case INVOKE: "CInvoke"
			case RESULT: "CResult"
			default: ""
		}
	}
	
	def doGenerate(Binding b) '''
	{
		"bindingType": «IF b.binfo instanceof InternalBinding»"Internal"«ELSE»"External"«ENDIF»,
		"from": «doGenerate(b.binfo.point1)»,
		"to": «doGenerate(b.binfo.point2)»
	}
	'''
	
	def doGenerate(JoinPoint p) {
		if (p instanceof EJoinPoint)
			doGenerate(p as EJoinPoint)
		else
			doGenerate(p as IJoinPoint)
	}
	
	def doGenerate(EJoinPoint p) '''
	{
		"name": [],
		"operation": «doGenerate(p.operation)»
	}	'''
	
	def doGenerate(IJoinPoint p) '''
	{
		"name": ["«p.component.name»"],
		"operation": ["«p.operation»"]
	}
	'''
		
}
