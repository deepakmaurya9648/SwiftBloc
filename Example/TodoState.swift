import Foundation
import SwiftBloc

// Using the BlocBaseState for handling different states
typealias TodoState = BlocBaseState<[Todo], Error>
