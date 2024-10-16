import Lottie

enum LottieAsset: String {
	case working
	case closingComputer
}

extension LottieAnimation {
	static func named(_ localAsset: LottieAsset) -> LottieAnimation? {
		LottieAnimation.named(localAsset.rawValue)
	}
}
