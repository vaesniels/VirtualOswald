
protocol STTDelegate {
    func onSTTResultDidUpdate(result: String)
    func onTimerExpired(result: String)
}

protocol TopViewDelegate {
    func onTopViewDidClose()
    func onQuickReplyTapped(message: String)
}

protocol BottomViewDelegate {
    func onFabOpenedDidChange(isOpen: Bool)
    func onBottomViewShouldBeVisible(visible: Bool)
    func onRemoveButtonPressed()
    func onChatButtonPressed()
    func onAudioButtonPressed()
}

protocol ChatViewDelegate {
    func onSendButtonPressed()
}

protocol ARServiceDelegate{
    func onFinalmode()
    func onEditMode()
}

protocol SceneChangeCarouselDelegate {
    func onSceneSelected(name: String)
    func onBackDropPress()
}

protocol GameSceneDelegate {
    func onPlayerDied()
}

protocol NetworkDelegate {
    func OnNetworkConnected(isConnected: Bool)
}

protocol  TutorialDelegate {
    func OnGoToNextStep()
    func getStepWithState(nextState: TutorialState)
    func OnViewShouldDissapear()
    func onStateChanged(state: TutorialState)
}
