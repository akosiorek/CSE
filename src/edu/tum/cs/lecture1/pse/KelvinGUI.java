package edu.tum.cs.lecture1.pse;

import java.util.Observable;

// Class implemented for Kelvin
public class KelvinGUI extends TemperatureGUI {
	
	public KelvinGUI(TemperatureModel model, int h, int v) {
		super("Kelvin Temperature", model, h, v);
		setDisplay("" + model.getK());
		
		setController(new KelvinController(model, this));		
	}

	public void update(Observable t, Object o) { // Called from the Model
		setDisplay("" + model().getK());
	}


}
