/*
 * 在全局暴露一个 TMGraphic 对象
 * 设计文档：http://git.code.oa.com/wxweb/game-design/blob/master/global/TMGraphic/README.md
 */
(function() {

  // 默认从 Native 生成，如果 Native 没有生成，就声明一个
  if (typeof TMGraphic === 'undefined') {
    TMGraphic = {}
  }
 
 var g = TMGraphic
 g.XMLHttpRequest = MagicBrush.HttpRequest
 g.Audio = MagicBrush.Audio
 g.XMLHttpRequest = MagicBrush.HttpRequest
 g.Download = MagicBrush.Download
 g.WSS = MagicBrush.WebSocketTask
 
 g.fs = {}
 g.fs.FileReader = MagicBrush.FileReader
 g.fs.readFileSync = function (path, encoding) { return ej.readFileSync(path, encoding) }
 g.FileSystem = {}
 g.FileSystem.readFile = function (path) { return ej.readFileSync(path, 'utf8') }
g.FileSystem.readFileAB = function (path) { return ej.readFileSync(path) }
 
 // The 'ej' object provides some basic info and utility functions
 var ej = new MagicBrush.GlobalUtils()
 var Canvas = MagicBrush.Canvas
 var BindingObject = MagicBrush.BindingObject
 
 // 把全局暴露的 __wxConfig 挪到 TMGraphic
 if (typeof __wxConfig === 'undefined') {
   g.__wxConfig = {}
 } else {
   g.__wxConfig = __wxConfig
 }
 
 // TODO Reporter-SDK 里面会用到这个全局变量，不能直接移除
 // __wxConfig = undefined
 
 
 // 补充 __wxConfig 的属性
 g.__wxConfig.devicePixelRatio = ej.devicePixelRatio
 g.__wxConfig.screenWidth = ej.screenWidth
 g.__wxConfig.screenHeight = ej.screenHeight
 g.devicePixelRatio = ej.devicePixelRatio
 
 g.log = function (str) { ej.log(str) }
 
 const canvasSet = new Set()
 g.ScreenCanvas = function () {
     var canvas = new Canvas(1)
     canvasSet.add(canvas)
     var old = canvas.remove
     canvas.remove = () => {
       canvasSet.delete(canvas)
       old.call(canvas)
     }
     return canvas;
 }
 
 g.setTimeout = function (cb, t) { return ej.setTimeout(cb, t || 0) }
 g.setInterval = function(cb, t){ return ej.setInterval(cb, t || 0) }
 g.clearTimeout = function(id){ return ej.clearTimeout(id) }
 g.clearInterval = function(id){ return ej.clearInterval(id) }
 g.requestAnimationFrame = function(cb){ return ej.requestAnimationFrame(cb) }
 g.cancelAnimationFrame = function(id){ return ej.cancelAnimationFrame(id) }
 g.setPreferredFramesPerSecond = function(fps){ return ej.setPreferredFramesPerSecond(fps) }
 g.loadFont = function(path){ return ej.loadFont(path) }
 g.encodeArrayBuffer = function(str, code){ return ej.encodeArrayBuffer(str, code) }
 g.decodeArrayBuffer = function(buffer, code){ return ej.decodeArrayBuffer(buffer, code) }
 g.performanceNow = function(){ return ej.performanceNow() }
 g.recordFrame = function(canvasid){ return ej.recordFrame(canvasid) }
 g.getTextLineHeight = function(style,weight,size,family,text){ return ej.getTextLineHeight(style,weight,size,family,text) }
 g.startProfile = function () { return ej.startProfile() }
 g.stopProfile = function () { return ej.stopProfile() }
 g.getProfileResult = function () { return ej.getProfileResult() }
 g.decodeUint64Array = function () { return ej.decodeUint64Array.apply(ej, arguments) }
 g.decodeVarintArray = function () { return ej.decodeVarintArray.apply(ej, arguments) }
 g.getSystemInfo = function () { return ej.getSystemInfo() }
 
 g.OffscreenCanvas = function () {
     var c = new Canvas()
     c.uid = c.__canvasId()
     return c
 }

 g.SharedCanvas = function () {
    var c = new Canvas()
    c.uid = c.__canvasId()
    return c
 }
 
 g.setGlobalAttribute = function (a){return ej.setGlobalAttribute(a) }
 commandRender = function (str, sync){ return ej.batchRender(str, sync) }
 
 // TODO 临时暴露到全局以解决 Reporter 错误
 setTimeout = g.setTimeout;
 clearTimeout = g.clearTimeout;
 setInterval = g.setInterval;
 clearInterval = g.clearInterval;
 
 var Image = MagicBrush.Image;
 g.Image = function(w, h){
   var img = new Image(w, h)
   img.uid = img.__id();
   return img;
 }
 
 var screenCanvas = new MagicBrush.Canvas()
 var hasScreenCanvas = false
 g.Canvas = function () {
   if (hasScreenCanvas) {
       return g.OffscreenCanvas()
   } else {
     hasScreenCanvas = true
     screenCanvas.uid = screenCanvas.__canvasId()
     return screenCanvas
   }
 }
 g.AutoScreenCanvas = g.Canvas
 g.BindingObject = function () {
   return new BindingObject(ej)
 }
 g.EventHandler = {}
 g.EventHandler.ontouchstart = g.EventHandler.ontouchend = g.EventHandler.ontouchmove = null
 g.Path2D = MagicBrush.Path2D;
 g.ImageData = MagicBrush.ImageData;
 
 function copyTouchArray(touches) {
   return touches.map(function (touch) {
     return Object.assign({}, touch)
   })
 }
 
 var touchInput = new MagicBrush.TouchInput(screenCanvas)
 g.EventHandler.addEventListener = function(eventName, callback) {
     g.EventHandler['on'+eventName] = callback;
 }
 g.EventHandler.removeEventListener = function(eventName, callback) {
     g.EventHandler['on'+eventName] = null;
 }
 
 var touchEventNames = ['ontouchstart', 'ontouchmove', 'ontouchend', 'ontouchcancel']
 touchEventNames.forEach(function (touchEventName) {
   var FUNCTION_STR = 'function'
   var OBJECT_STR = 'object'
   var dstName = touchEventName + 'Dst'
   touchInput[touchEventName] = function (touches, changedTouches, timestamp) {
     var stop = false
     var target  = null;
     if(touches.length > 0 && canvasSet.has(touches[0].target)){
      target = touches[0].target;
     }
     if(target == null && changedTouches.length > 0 && canvasSet.has(changedTouches[0].target)){
      target = changedTouches[0].target;
     }
     if(target){
       if (typeof target[touchEventName] === 'function'){
         var event = {
             type: touchEventName,
             touches: copyTouchArray(touches),
             changedTouches: copyTouchArray(changedTouches),
             preventDefault: function(){},
             stopPropagation: function(){},
             timeStamp: timestamp
           }
         var ret = target[touchEventName](event)
         if (typeof ret === 'boolean' && !ret) stop = true
       }
     }
     if (stop) return
     if (typeof g.EventHandler[touchEventName] === FUNCTION_STR) {
       var event
       if (typeof g.EventHandler[dstName] === OBJECT_STR) {
         event = g.EventHandler[dstName]
         event.type = touchEventName
         event.touches = touches
         event.changedTouches = changedTouches
         event.timeStamp = timestamp
       } else {
         event = {
           type: touchEventName,
           touches: copyTouchArray(touches),
           changedTouches: copyTouchArray(changedTouches),
           preventDefault: function(){},
           stopPropagation: function(){},
           timeStamp: timestamp
         }
       }
        // console.log('NativeGlobal:'+touchEventName)
       g.EventHandler[touchEventName].call(g, event)
     }
   }
 })
 
 ej.onbindingobjectdestruct = function (id) {
   if (typeof g.EventHandler.onbindingobjectdestruct === 'function') {
     g.EventHandler.onbindingobjectdestruct.call(g, id)
   }
 }
 
 g.createSignal = function () { return ej.createSignal() }
     
 
 var global = (function () { return this })()
 delete global.MagicBrush
 })();
 
 var window = (function() { return this })();
 (function() {
     var nativelog = TMGraphic.log;
     var originalConsoleLog = window.console.log;
     var originalConsoleInfo = window.console.info;
     var originalConsoleVerbose = window.console.verbose;
     var originalConsoleError = window.console.error;
     var originalConsoleWarn = window.console.warn;
     var originalConsoleDebug = window.console.debug;
     function createFn(tag) {
         return function(...args) {
             switch (tag) {
                 case "[LOG]":
                     originalConsoleLog(...args);
                     break;
                 case "[INFO]":
                     originalConsoleInfo(...args);
                     break;
                 case "[VERB]":
                     originalConsoleVerbose(...args);
                     break;
                 case "[ERRO]":
                     originalConsoleError(...args);
                     break;
                 case "[WARN]":
                     originalConsoleWarn(...args);
                     break;
                 case "[DEBUG]":
                     originalConsoleDebug(...args);
                     break;
             }
             
             var argsList = [...args];
             var argsString = '';
             
             argsList.forEach(item => {
                 try {
                     var string = JSON.stringify(item);
                     argsString += `${string}__LOG_END__`;
                 } catch(err) {
                     argsString += `${item}__LOG_END__`;
                 }
             });
             nativelog(`${tag} ${argsString}`);
         }
     }
     window.console.log = createFn("[LOG]")
     window.console.info = createFn("[INFO]")
     window.console.verbose = createFn("[VERB]")
     window.console.error = createFn("[ERRO]")
     window.console.warn = createFn("[WARN]")
     window.console.debug = createFn("[DEBUG]")
 })();
 
 
 (function() {
 function attach(name) {
     window[name] = TMGraphic[name]
 }
 attach("setInterval")
 attach("setTimeout")
 attach("requestAnimationFrame")
 attach("cancelAnimationFrame")
 attach("devicePixelRatio")
 })();
 
 window.attachEvent = function () {};
 
