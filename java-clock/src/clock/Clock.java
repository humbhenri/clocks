package clock;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Calendar;
import java.util.GregorianCalendar;

import javax.swing.JPanel;
import javax.swing.Timer;

public class Clock extends JPanel {
	private static final long serialVersionUID = 1L;
	private int hoursHand;
	private int minutesHand;
	private int secondsHand;
	private final static double hoursHandSize = 0.3;
	private final static double minutesHandSize = 0.6;
	private final static double secondsHandSize = 0.75;
	
	public Clock() {
		super();
		setTime();
		Timer t = new Timer(1000, new ActionListener(){
			public void actionPerformed(ActionEvent e) {
				Clock.this.updateClock();
				Clock.this.repaint();
			}
		});
		t.start();
	}
	
	
	private void setTime() {
		Calendar cal = new GregorianCalendar();
		hoursHand = cal.get(Calendar.HOUR) * 5;
		minutesHand = cal.get(Calendar.MINUTE);
		secondsHand = cal.get(Calendar.SECOND);
	}
	
	
	public void paint(Graphics g) {
		super.paint(g);
		Graphics2D g2 = (Graphics2D) g;
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
				RenderingHints.VALUE_ANTIALIAS_ON);

		// draw face
		int centerX = getWidth() / 2;
		int centerY = getHeight() / 2;
		int radius = (int) (Math.min(getHeight(), getWidth()) / 4.0);
		g2.fillOval(centerX - radius, centerY - radius, (int) radius * 2,
				(int) radius * 2);

		// draw hands
		g2.setColor(Color.GREEN);
		g2.setStroke(new BasicStroke(3.0f));
		g2.drawLine(centerX, centerY, (int) (centerX + radius * hoursHandSize
				* Math.cos(toRadian(hoursHand))), (int) (centerY + radius
				* hoursHandSize * Math.sin(toRadian(hoursHand))));
		g2.drawLine(centerX, centerY, (int) (centerX + radius * minutesHandSize
				* Math.cos(toRadian(minutesHand))), (int) (centerY + radius
				* minutesHandSize * Math.sin(toRadian(minutesHand))));
		g2.setColor(Color.RED);
		g2.setStroke(new BasicStroke(1.0f));
		g2.drawLine(centerX, centerY, (int) (centerX + radius * secondsHandSize
				* Math.cos(toRadian(secondsHand))), (int) (centerY + radius
				* secondsHandSize * Math.sin(toRadian(secondsHand))));
		System.out.println(hoursHand + " "+ Math.cos(10));
	}

	
	private double toRadian(int x) {
		return x * Math.PI/30.0 - (Math.PI/2.0);
	}
	
	
	private void updateClock() {
		secondsHand = (secondsHand + 1) % 60;
		if (secondsHand == 0) {
			minutesHand = (minutesHand + 1) % 60;
			if (minutesHand == 0) {
				hoursHand = (hoursHand + 5) % 60;
			}
		}
	}
}
