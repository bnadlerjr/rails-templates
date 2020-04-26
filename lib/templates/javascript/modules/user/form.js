export default function (facade) {
    let form, fileInput

    function handleReaderLoaded (event) {
        facade.emit('AvatarEditorFileChanged', {
            submitURL: form.attr('action'),
            fieldName: fileInput.attr('name'),
            dataURL: event.target.result
        })
    }

    function handleFileInputChange (event) {
        if (event.target.files && event.target.files[0]) {
            const reader = new FileReader()
            reader.onload = handleReaderLoaded
            reader.readAsDataURL(event.target.files[0])
        }
    }

    return {
        init: function () {
            form = this.el
            fileInput = form.find('input[type="file"]')
            fileInput.on('change', handleFileInputChange)
        }
    }
};
