import Lottie

enum LottieAsset: String {
	case clockTime
	case hello
	case night
	case notFound
	case working
	case closingComputer
	case computer
}

extension LottieAnimation {
	static func named(_ localAsset: LottieAsset) -> LottieAnimation? {
		LottieAnimation.named(localAsset.rawValue)
	}
}
