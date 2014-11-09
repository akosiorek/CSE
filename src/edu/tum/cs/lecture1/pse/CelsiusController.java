package edu.tum.cs.lecture1.pse;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class CelsiusController extends TemperatureController {

	public CelsiusController(TemperatureModel model, TemperatureGUI gui) {
		super(model, gui);
	}

	@Override
	public ActionListener getRaiseTempListener() {
		return new RaiseTempListener();
	}

	@Override
	public ActionListener getLowerTempListener() {
		return new LowerTempListener();
	}

	@Override
	public ActionListener getDisplayListener() {
		return new DisplayListener();
	}
	
	private class RaiseTempListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			model.setC(model.getC() + 1.0);
		}
	}

	private class LowerTempListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			model.setC(model.getC() - 1.0);
		}
	}

	private class DisplayListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			double value = gui.getDisplay();
			model.setC(value);
		}
	}

}
