package edu.tum.cs.lecture1.pse;
 
import java.util.Observable;

public class CelsiusGUI extends TemperatureGUI {

	public CelsiusGUI(TemperatureModel model, int h, int v) {
		super("Celsius Temperature", model, h, v);
		setDisplay("" + model.getC());
		setController(new CelsiusController(model, this));
	}

	public void update(Observable t, Object o) { // Called from the Model
		setDisplay("" + model().getC());
	}


}