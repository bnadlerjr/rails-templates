export default function (facade) {
    let modal, image, cropper, submitURL, fieldName

    function handleFileChanged (event) {
        image.attr('src', event.details.dataURL)
        submitURL = event.details.submitURL
        fieldName = event.details.fieldName
        modal.modal('show')
    }

    function handleFileUploaded (event) {
        modal.modal('hide')
    }

    function handleModalShown (event) {
        cropper = facade.createCropper(image[0], {
            aspectRatio: 1,
            viewMode: 2,
            rotable: false,
            scalable: false,
            zoomable: false
        })
    }

    function handleModalHidden (event) {
        cropper.destroy()
    }

    function handleUploadButtonClicked (event) {
        cropper.toBlob((blob) => {
            const formData = new FormData()
            formData.append(fieldName, blob)
            facade.request(submitURL, {
                method: 'PUT',
                dataType: 'json',
                data: formData,
                processData: false,
                contentType: false,
                success (user) {
                    facade.emit('AvatarEditorFileUploaded', {
                        imageURL: user.avatar
                    })
                }
            })
        })
    }

    return {
        init: function () {
            modal = this.el
            image = modal.find('img')
            facade.listen('AvatarEditorFileChanged', handleFileChanged)
            facade.listen('AvatarEditorFileUploaded', handleFileUploaded)
            modal.on('shown.bs.modal', handleModalShown)
            modal.on('hidden.bs.modal', handleModalHidden)
            modal.find('.modal-footer > button').on('click', handleUploadButtonClicked)
        }
    }
}
