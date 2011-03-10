package clock;

import javax.swing.JFrame;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		JFrame frame = new JFrame("Java Clock");
		frame.setSize(360, 360);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		Clock clock = new Clock();
		frame.add(clock);
		
		frame.setVisible(true);
	}

}
