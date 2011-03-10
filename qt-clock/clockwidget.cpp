#include "clockwidget.h"
#include <QPainter>
#include <QTimerEvent>
#include <QPoint>
#include <cmath>
#include <QTime>

ClockWidget::ClockWidget(QWidget *parent) :
    QWidget(parent)
{
   timerId = startTimer(1000);
   setTime();
}


ClockWidget::~ClockWidget()
{
   killTimer(timerId);
   timerId = 0;
}


void ClockWidget::setTime()
{
   QTime now = QTime::currentTime();
   hourHand = (now.hour()%12)*5;
   minuteHand = now.minute();
   secondsHand = now.second();
}


void ClockWidget::paintEvent(QPaintEvent *event)
{
   QPainter painter(this);
   center.setX(width()/2);
   center.setY(height()/2);

   int radius = qMin(width()/4, height()/4);
   painter.setRenderHint(QPainter::Antialiasing, true);
   painter.setBrush(QBrush(Qt::black, Qt::SolidPattern));
   painter.drawEllipse(center, radius, radius);

   double hourX = center.x() + 0.25 * radius * cos(toRadian(hourHand));
   double hourY = center.y() + 0.25 * radius * sin(toRadian(hourHand));
   double minuteX = center.x() + 0.5 * radius * cos(toRadian(minuteHand));
   double minuteY = center.y() + 0.5 * radius * sin(toRadian(minuteHand));
   double secondX = center.x() + 0.75 * radius * cos(toRadian(secondsHand));
   double secondY = center.y() + 0.75 * radius * sin(toRadian(secondsHand));
   painter.setPen(QPen(Qt::green, 3));
   painter.drawLine(center.x(), center.y(), hourX, hourY);
   painter.drawLine(center.x(), center.y(), minuteX, minuteY);
   painter.setPen(QPen(Qt::red, 1));
   painter.drawLine(center.x(), center.y(), secondX, secondY);
}


void ClockWidget::timerEvent(QTimerEvent *te)
{
   if (te->timerId() == timerId) {
      secondsHand = (secondsHand + 1) % 60;
      if(secondsHand == 0) {
         minuteHand = (minuteHand + 1) % 60;
         if (minuteHand == 0) {
            hourHand = (hourHand + 5) % 60;
         }
      }
      repaint();
   }
   else {
      QWidget::timerEvent(te);
   }
}
