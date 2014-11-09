package edu.tum.cs.lecture1.pse;


import java.util.Observable;

public class FahrenheitGUI extends TemperatureGUI {
	
	public FahrenheitGUI(TemperatureModel model, int h, int v) {
		super("Fahrenheit Temperature", model, h, v);
		setDisplay("" + model.getF());
		setController(new FahrenheitController(model, this));
	}

	public void update(Observable t, Object o) { // Called from the Model
		setDisplay("" + model().getF());
	}

	
}
