package main;

import jess.JessException;
import jess.Rete;

public class MainEngine{
	
	public static Rete engine;
	
	public MainEngine() {
		engine = new Rete();
		
		try {
			engine.batch("main.clp");
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
	
	public static void main(String[] args) {
		new MainEngine();
	}
}