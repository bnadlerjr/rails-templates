import $ from 'jquery'
import MiniApp from './mini-app'
import facade from './facade'
import avatarModal from './modules/avatar/modal'
import avatarImage from './modules/avatar/image'
import userForm from './modules/user/form'

$(document).on('turbolinks:load', function () {
    const avatar = new MiniApp(facade)
    avatar.register('.avatar', avatarImage)
    avatar.register('#user-form', userForm)
    avatar.register('#avatar-modal', avatarModal)
    avatar.start()
})
