import XCTest
@testable import MilkyWay

class NasaImageTests: XCTestCase {

    func testCreate_noPhotographer() {

        guard let json = readJSONData("image") else {
            XCTFail("Failed to read json file")
            return
        }

        do {
            let sut = try JSONDecoder().decode(NasaImage.self, from: json)
            XCTAssertNil(sut.data.first?.photographer)
            XCTAssertEqual(sut.data.first?.creator, "NASA/JPL/Arizona State University")
            XCTAssertEqual(sut.data.first?.title, "THEMIS Images as Art #22")
            XCTAssertEqual(sut.data.first?.description, "THEMIS Images as Art #22")
            XCTAssertEqual(sut.data.first?.dateCreated, "2004-03-02T14:05:00Z")
            XCTAssertEqual(sut.links.first?.imageUrl, "https://images-assets.nasa.gov/image/PIA05602/PIA05602~thumb.jpg")
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testCreate_noCreator() {

        guard let json = readJSONData("image_photographer") else {
            XCTFail("Failed to read json file")
            return
        }

        do {
            let sut = try JSONDecoder().decode(NasaImage.self, from: json)
            XCTAssertNil(sut.data.first?.creator)
            XCTAssertEqual(sut.data.first?.photographer, "Tom Trower")
            XCTAssertEqual(sut.data.first?.title, "ARC-2002-ACD02-0056-22")
            XCTAssertEqual(sut.data.first?.description, "VSHAIP test in 7x10ft#1 W.T. (multiple model configruations) V-22 helicopter shipboard aerodynamic interaction program: L-R seated Allen Wadcox, (standind) Mark Betzina, seated in front of computer Gloria Yamauchi, in background Kurt Long.")
            XCTAssertEqual(sut.data.first?.dateCreated, "2002-03-20T00:00:00Z")
            XCTAssertEqual(sut.links.first?.imageUrl, "https://images-assets.nasa.gov/image/ARC-2002-ACD02-0056-22/ARC-2002-ACD02-0056-22~thumb.jpg")
        } catch {
            XCTFail(String(describing: error))
        }
    }
}
