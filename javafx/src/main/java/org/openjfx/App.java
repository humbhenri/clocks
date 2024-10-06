package org.openjfx;

import java.util.Calendar;
import java.util.GregorianCalendar;

import javafx.application.Application;
import javafx.beans.binding.Bindings;
import javafx.beans.binding.DoubleBinding;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Ellipse;
import javafx.scene.shape.Line;
import javafx.stage.Stage;

/**
 * JavaFX App
 */
public class App extends Application {

    private static final int HEIGHT = 480;
	private static final int WIDTH = 640;
	private int hoursValue;
	private int minutesValue;
	private int secondsValue;
	private final static double HOURS_HAND_SIZE = 0.5;
	private final static double MINUTES_HAND_SIZE = 0.6;
	private final static double SECONDS_HAND_SIZE = 0.75;
	private Ellipse clock;
	private DoubleBinding radius;
	
	private double toRadian(double x) {
		return x * Math.PI/30.0 - (Math.PI/2.0);
	}
	
	private void setTime() {
		Calendar cal = new GregorianCalendar();
		hoursValue = cal.get(Calendar.HOUR) * 5;
		minutesValue = cal.get(Calendar.MINUTE);
		secondsValue = cal.get(Calendar.SECOND);
	}
	
	private Line createHand(double handSize, double value) {
		var line = new Line();
		
		line.startXProperty().bind(clock.centerXProperty());
		
		var endX = Bindings.createDoubleBinding(() -> {
			return (clock.getCenterX() + radius.get() * handSize
					* Math.cos(toRadian(value)));
		}, clock.centerXProperty(), radius);
		
		line.endXProperty().bind(endX);
		
		line.startYProperty().bind(clock.centerYProperty());
		var endY = Bindings.createDoubleBinding(() -> {
			return (clock.getCenterY() + radius.get() * handSize
					* Math.sin(toRadian(value)));
		}, clock.centerYProperty(), radius);
		
		line.endYProperty().bind(endY);
		
		return line;
	}

	@Override
    public void start(Stage stage) {
		setTime();
		radius = Bindings.createDoubleBinding(() -> 
			Math.min(stage.getWidth(), stage.getHeight()) * 0.35, 
			stage.widthProperty(), 
			stage.heightProperty());
		clock = new Ellipse();
		clock.centerXProperty().bind(stage.widthProperty().divide(2));
		clock.centerYProperty().bind(stage.heightProperty().divide(2));
		clock.radiusXProperty().bind(radius);
		clock.radiusYProperty().bind(radius);
		clock.setFill(Color.WHITE);
		clock.setStroke(Color.BLACK);
		
		var hourHand = createHand(HOURS_HAND_SIZE, hoursValue);
		hourHand.setStroke(Color.LIGHTGREEN);
		
		var minuteHand = createHand(MINUTES_HAND_SIZE, minutesValue);
		minuteHand.setStroke(Color.BLACK);
		
		var secondHand = createHand(SECONDS_HAND_SIZE, secondsValue);
		secondHand.setStroke(Color.RED);
        
		var scene = new Scene(new Pane(clock, hourHand, minuteHand, secondHand), WIDTH, HEIGHT);
        stage.setResizable(true);
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }

}