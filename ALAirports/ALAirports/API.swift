//  This file was automatically generated and should not be edited.

import Apollo

public final class AllAirportsQuery: GraphQLQuery {
  public static let operationDefinition =
    "query AllAirports {" +
    "  allAirports {" +
    "    __typename" +
    "    airportId" +
    "    identifier" +
    "    airportType" +
    "    name" +
    "    elevation" +
    "    isoCountry" +
    "    isoRegion" +
    "    municipality" +
    "    gpsCode" +
    "    iataCode" +
    "    localCode" +
    "    homepageURL" +
    "    wikipediaURL" +
    "    scheduledService" +
    "    latitude" +
    "    longitude" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let allAirports: [AllAirport]

    public init(reader: GraphQLResultReader) throws {
      allAirports = try reader.list(for: Field(responseName: "allAirports"))
    }

    public struct AllAirport: GraphQLMappable {
      public let __typename: String
      public let airportId: Int?
      public let identifier: String?
      public let airportType: String?
      public let name: String?
      public let elevation: Int?
      public let isoCountry: String?
      public let isoRegion: String?
      public let municipality: String?
      public let gpsCode: String?
      public let iataCode: String?
      public let localCode: String?
      public let homepageUrl: String?
      public let wikipediaUrl: String?
      public let scheduledService: Bool?
      public let latitude: Double?
      public let longitude: Double?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        airportId = try reader.optionalValue(for: Field(responseName: "airportId"))
        identifier = try reader.optionalValue(for: Field(responseName: "identifier"))
        airportType = try reader.optionalValue(for: Field(responseName: "airportType"))
        name = try reader.optionalValue(for: Field(responseName: "name"))
        elevation = try reader.optionalValue(for: Field(responseName: "elevation"))
        isoCountry = try reader.optionalValue(for: Field(responseName: "isoCountry"))
        isoRegion = try reader.optionalValue(for: Field(responseName: "isoRegion"))
        municipality = try reader.optionalValue(for: Field(responseName: "municipality"))
        gpsCode = try reader.optionalValue(for: Field(responseName: "gpsCode"))
        iataCode = try reader.optionalValue(for: Field(responseName: "iataCode"))
        localCode = try reader.optionalValue(for: Field(responseName: "localCode"))
        homepageUrl = try reader.optionalValue(for: Field(responseName: "homepageURL"))
        wikipediaUrl = try reader.optionalValue(for: Field(responseName: "wikipediaURL"))
        scheduledService = try reader.optionalValue(for: Field(responseName: "scheduledService"))
        latitude = try reader.optionalValue(for: Field(responseName: "latitude"))
        longitude = try reader.optionalValue(for: Field(responseName: "longitude"))
      }
    }
  }
}