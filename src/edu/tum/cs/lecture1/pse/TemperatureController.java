package edu.tum.cs.lecture1.pse;

import java.awt.event.ActionListener;

public abstract class TemperatureController {
	protected final TemperatureModel model;
	protected final TemperatureGUI gui;
	
	public TemperatureController(TemperatureModel model, TemperatureGUI gui) {
		this.model = model;
		this.gui = gui;
	}
	
	public abstract ActionListener getRaiseTempListener();
	public abstract ActionListener getLowerTempListener();
	public abstract ActionListener getDisplayListener();
}
