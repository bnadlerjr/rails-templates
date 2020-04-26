export default function (facade) {
    return {
        init: function () {
            const image = this.el
            facade.listen('AvatarEditorFileUploaded', function (event) {
                image.attr('src', event.details.imageURL)
            })
        }
    }
}
