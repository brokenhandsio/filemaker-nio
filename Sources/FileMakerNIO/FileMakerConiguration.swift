public struct FileMakerConfiguration {
    public let scheme: String
    public let hostname: String
    public let databaseName: String
    public let username: String
    public let password: String
    
    public init(scheme: String = "https", hostname: String, databaseName: String, username: String, password: String) {
        self.scheme = scheme
        self.hostname = hostname
        self.databaseName = databaseName
        self.username = username
        self.password = password
    }
}
