import jQuery from 'jquery'
import Cropper from 'cropperjs/dist/cropper'

const facade = (function ($) {
    var o = $({})
    var _cropper

    return {
        query: function (selector) {
            return $(selector)
        },
        listen: function () {
            o.on.apply(o, arguments)
        },
        emit: function (eventName, details) {
            var event = $.Event(eventName, { details: details })
            o.trigger(event)
        },
        createCropper: function (image, options) {
            _cropper = new Cropper(image, options)
            return {
                destroy: function () {
                    _cropper.destroy()
                },
                toBlob: function (fn) {
                    return _cropper.getCroppedCanvas().toBlob(fn)
                }
            }
        },
        request: function (url, options) {
            $.ajax(url, options)
        }
    }
})(jQuery)

export default facade
