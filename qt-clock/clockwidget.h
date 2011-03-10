#ifndef CLOCKWIDGET_H
#define CLOCKWIDGET_H

#include <QWidget>
#include <cmath>

class ClockWidget : public QWidget
{
    Q_OBJECT
public:
   explicit ClockWidget(QWidget *parent = 0);
   ~ClockWidget();
   void setTime();
signals:

public slots:

private:
    void paintEvent(QPaintEvent *);
    void timerEvent(QTimerEvent *);
    inline double toRadian(double x) {return (x * M_PI/30.0) - (M_PI/2.0);}
    QPoint center;
    int hourHand;
    int minuteHand;
    int secondsHand;
    int timerId;

};

#endif // CLOCKWIDGET_H
