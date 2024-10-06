package org.openjfx;

import java.util.Calendar;
import java.util.GregorianCalendar;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;
import javafx.beans.binding.Bindings;
import javafx.beans.binding.DoubleBinding;
import javafx.beans.binding.ObjectBinding;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Ellipse;
import javafx.scene.shape.Line;
import javafx.stage.Stage;
import javafx.util.Duration;

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
	private ObjectBinding<Double> radius;

	private double handX(double size, double value) {
		return clock.getCenterX() + radius.get() * size * Math.cos(toRadian(value));
	}

	private double handY(double size, double value) {
		return clock.getCenterY() + radius.get() * size * Math.sin(toRadian(value));
	}

	private double toRadian(double x) {
		return x * Math.PI / 30.0 - (Math.PI / 2.0);
	}

	private void setTime() {
		Calendar cal = new GregorianCalendar();
		hoursValue = cal.get(Calendar.HOUR) * 5;
		minutesValue = cal.get(Calendar.MINUTE);
		secondsValue = cal.get(Calendar.SECOND);
	}
	
	@Override
	public void start(Stage stage) {
		setTime();

		radius = Bindings.createObjectBinding(() -> {
			double minDimension = Math.min(stage.getWidth(), stage.getHeight());
			return minDimension > 0 ? minDimension / 2 : Math.min(WIDTH, HEIGHT) / 2;
		}, stage.widthProperty(), stage.heightProperty());

		clock = new Ellipse();
		clock.centerXProperty().bind(stage.widthProperty().divide(2));
		clock.centerYProperty().bind(stage.heightProperty().divide(2));
		clock.radiusXProperty().bind(radius);
		clock.radiusYProperty().bind(radius);
		clock.setFill(Color.WHITE);
		clock.setStroke(Color.BLACK);

		var hourHand = new Line();
		hourHand.startXProperty().bind(clock.centerXProperty());
		hourHand.startYProperty().bind(clock.centerYProperty());
		var hourHandEndX = new SimpleDoubleProperty(handX(HOURS_HAND_SIZE, hoursValue));
		var hourHandEndY = new SimpleDoubleProperty(handY(HOURS_HAND_SIZE, hoursValue));
		hourHand.endXProperty().bind(hourHandEndX);
		hourHand.endYProperty().bind(hourHandEndY);
		hourHand.setStroke(Color.RED);
		hourHand.setStroke(Color.LIGHTGREEN);

		var minuteHand = new Line();
		minuteHand.startXProperty().bind(clock.centerXProperty());
		minuteHand.startYProperty().bind(clock.centerYProperty());
		var minuteHandEndX = new SimpleDoubleProperty(handX(MINUTES_HAND_SIZE, minutesValue));
		var minuteHandEndY = new SimpleDoubleProperty(handY(MINUTES_HAND_SIZE, minutesValue));
		minuteHand.endXProperty().bind(minuteHandEndX);
		minuteHand.endYProperty().bind(minuteHandEndY);
		minuteHand.setStroke(Color.BLACK);

		var secondHand = new Line();
		secondHand.startXProperty().bind(clock.centerXProperty());
		secondHand.startYProperty().bind(clock.centerYProperty());
		var secondHandEndX = new SimpleDoubleProperty(handX(SECONDS_HAND_SIZE, secondsValue));
		var secondHandEndY = new SimpleDoubleProperty(handY(SECONDS_HAND_SIZE, secondsValue));
		secondHand.endXProperty().bind(secondHandEndX);
		secondHand.endYProperty().bind(secondHandEndY);
		secondHand.setStroke(Color.RED);

		var timeline = new Timeline(new KeyFrame(Duration.seconds(1), event -> {
			setTime();
			hourHandEndX.set(handX(HOURS_HAND_SIZE, hoursValue));
			hourHandEndY.set(handY(HOURS_HAND_SIZE, hoursValue));
			minuteHandEndX.set(handX(MINUTES_HAND_SIZE, minutesValue));
			minuteHandEndY.set(handY(MINUTES_HAND_SIZE, minutesValue));
			secondHandEndX.set(handX(SECONDS_HAND_SIZE, secondsValue));
			secondHandEndY.set(handY(SECONDS_HAND_SIZE, secondsValue));
		}));
		timeline.setCycleCount(Timeline.INDEFINITE);
		timeline.play();

		var scene = new Scene(new Pane(clock, hourHand, minuteHand, secondHand), WIDTH, HEIGHT);
		stage.setResizable(true);
		stage.setScene(scene);

		stage.setTitle("Clock");
		stage.show();
	}

	public static void main(String[] args) {
		launch();
	}

}