//  This file was automatically generated and should not be edited.

import Apollo

public final class SubstancesQuery: GraphQLQuery {
  public static let operationDefinition =
    "query Substances {" +
    "  substances(limit: 300) {" +
    "    __typename" +
    "    name" +
    "    url" +
    "    featured" +
    "    addictionPotential" +
    "    crossTolerances" +
    "    summary" +
    "    images {" +
    "      __typename" +
    "      thumb" +
    "      image" +
    "    }" +
    "    dangerousInteractions {" +
    "      __typename" +
    "      name" +
    "    }" +
    "    class {" +
    "      __typename" +
    "      chemical" +
    "      psychoactive" +
    "    }" +
    "    tolerance {" +
    "      __typename" +
    "      full" +
    "      half" +
    "      zero" +
    "    }" +
    "    effects {" +
    "      __typename" +
    "      name" +
    "      url" +
    "    }" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let substances: [Substance?]?

    public init(reader: GraphQLResultReader) throws {
      substances = try reader.optionalList(for: Field(responseName: "substances", arguments: ["limit": 300]))
    }

    public struct Substance: GraphQLMappable {
      public let __typename: String
      public let name: String?
      public let url: String?
      public let featured: Bool?
      public let addictionPotential: String?
      public let crossTolerances: [String?]?
      public let summary: String?
      public let images: [Image?]?
      public let dangerousInteractions: [DangerousInteraction?]?
      public let `class`: Class?
      public let tolerance: Tolerance?
      public let effects: [Effect?]?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        name = try reader.optionalValue(for: Field(responseName: "name"))
        url = try reader.optionalValue(for: Field(responseName: "url"))
        featured = try reader.optionalValue(for: Field(responseName: "featured"))
        addictionPotential = try reader.optionalValue(for: Field(responseName: "addictionPotential"))
        crossTolerances = try reader.optionalList(for: Field(responseName: "crossTolerances"))
        summary = try reader.optionalValue(for: Field(responseName: "summary"))
        images = try reader.optionalList(for: Field(responseName: "images"))
        dangerousInteractions = try reader.optionalList(for: Field(responseName: "dangerousInteractions"))
        `class` = try reader.optionalValue(for: Field(responseName: "class"))
        tolerance = try reader.optionalValue(for: Field(responseName: "tolerance"))
        effects = try reader.optionalList(for: Field(responseName: "effects"))
      }

      public struct Image: GraphQLMappable {
        public let __typename: String
        public let thumb: String?
        public let image: String?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          thumb = try reader.optionalValue(for: Field(responseName: "thumb"))
          image = try reader.optionalValue(for: Field(responseName: "image"))
        }
      }

      public struct DangerousInteraction: GraphQLMappable {
        public let __typename: String
        public let name: String?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          name = try reader.optionalValue(for: Field(responseName: "name"))
        }
      }

      public struct Class: GraphQLMappable {
        public let __typename: String
        public let chemical: [String?]?
        public let psychoactive: [String?]?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          chemical = try reader.optionalList(for: Field(responseName: "chemical"))
          psychoactive = try reader.optionalList(for: Field(responseName: "psychoactive"))
        }
      }

      public struct Tolerance: GraphQLMappable {
        public let __typename: String
        public let full: String?
        public let half: String?
        public let zero: String?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          full = try reader.optionalValue(for: Field(responseName: "full"))
          half = try reader.optionalValue(for: Field(responseName: "half"))
          zero = try reader.optionalValue(for: Field(responseName: "zero"))
        }
      }

      public struct Effect: GraphQLMappable {
        public let __typename: String
        public let name: String?
        public let url: String?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          name = try reader.optionalValue(for: Field(responseName: "name"))
          url = try reader.optionalValue(for: Field(responseName: "url"))
        }
      }
    }
  }
}