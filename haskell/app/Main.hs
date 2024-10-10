{-# LANGUAGE PatternSynonyms, OverloadedStrings #-}
import qualified GI.Cairo
import qualified GI.Gdk as GDK
import qualified GI.Gtk as GTK
import GI.GLib (pattern PRIORITY_DEFAULT, timeoutAdd)
import GI.Cairo.Render.Connector (renderWithContext)
import GI.Cairo.Render
import Data.Time
import Data.Text as Text

centerW :: GTK.IsWidget widget => widget -> Render ()
centerW widget = do
  width  <- liftIO $ GTK.widgetGetAllocatedWidth  widget
  height <- liftIO $ GTK.widgetGetAllocatedHeight widget
  let size = min width height
  let w = fromIntegral width
      h = fromIntegral height
      s = fromIntegral size
  scale s s
  translate ((w/s)/2) ((h/s)/2)

drawClockBackground :: GTK.IsWidget widget => widget -> Render ()
drawClockBackground canvas = do
  save
  centerW canvas
  setSourceRGB 1 1 1
  rectangle (-1) (-1) 2 2
  fill
  drawClockFace
  scale 0.4 0.4
  restore

drawClockHands :: GTK.IsWidget widget => widget -> Render ()
drawClockHands canvas = do
  save
  centerW canvas
  scale 0.4 0.4
  time <- liftIO (localTimeOfDay . zonedTimeToLocalTime <$> getZonedTime)
  let hours   = fromIntegral (todHour time `mod` 12)
      minutes = fromIntegral (todMin time)
      seconds = realToFrac (todSec time)
  drawHourHand hours minutes seconds
  drawMinuteHand minutes seconds
  drawSecondHand seconds
  restore

drawClockFace :: Render ()
drawClockFace = do
  save
  setSourceRGB 1 1 1
  arc 0 0 (60/150) 0 (pi*2)
  -- fill
  restore

drawHourHand :: Double -> Double -> Double -> Render ()
drawHourHand hours minutes seconds = do
  save
  rotate (-pi/2)
  rotate ( (pi/6) * hours
         + (pi/360) * minutes
         + (pi/21600) * seconds)
  setLineWidth (1/60)
  setSourceRGB 0.16 0.18 0.19
  moveTo 0 0
  lineTo (7/15) 0
  stroke
  restore

drawMinuteHand :: Double -> Double -> Render ()
drawMinuteHand minutes seconds = do
  save
  rotate (-pi/2)
  rotate ( (pi/30) * minutes
         + (pi/1800) * seconds)
  setLineWidth (1/60)
  setSourceRGB 0.16 0.18 0.19
  moveTo 0 0
  lineTo (2/3) 0
  stroke
  restore

drawSecondHand :: Double -> Render ()
drawSecondHand seconds = do
  save
  rotate (-pi/2)
  rotate (seconds * pi/30);
  setSourceRGB 0.39 0.58 0.77
  setLineWidth (0.75/60)
  moveTo 0 0
  lineTo (3/5) 0
  stroke
  restore

drawCanvasHandler :: GTK.IsWidget widget => widget -> Render Bool
drawCanvasHandler widget =
  do drawClockBackground widget
     drawClockHands widget
     return True

main :: IO ()
main = do
  _ <- GTK.init Nothing
  window <- GTK.windowNew GTK.WindowTypeToplevel
  GTK.windowSetPosition window GTK.WindowPositionCenterAlways
  _ <- GTK.onWidgetDestroy window GTK.mainQuit
  GTK.widgetSetAppPaintable window True
  GTK.windowSetDefaultSize window 1024 768
  canvas <- GTK.drawingAreaNew
  GTK.containerAdd window canvas
  GTK.setWindowTitle window (pack "Haskell GTK Clock")
  _ <- GTK.onWidgetDraw canvas $ renderWithContext (drawCanvasHandler canvas)
  GTK.widgetShowAll window
  _ <- timeoutAdd GI.GLib.PRIORITY_DEFAULT 1000 (GTK.widgetQueueDraw window >> return True)
  GTK.main
