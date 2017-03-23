//  This file was automatically generated and should not be edited.

import Apollo

public final class AllAirportsQuery: GraphQLQuery {
  public static let operationDefinition =
    "query AllAirports {" +
    "  allAirports {" +
    "    __typename" +
    "    name" +
    "    identifier" +
    "    elevation" +
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
      public let name: String?
      public let identifier: String?
      public let elevation: Int?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        name = try reader.optionalValue(for: Field(responseName: "name"))
        identifier = try reader.optionalValue(for: Field(responseName: "identifier"))
        elevation = try reader.optionalValue(for: Field(responseName: "elevation"))
      }
    }
  }
}