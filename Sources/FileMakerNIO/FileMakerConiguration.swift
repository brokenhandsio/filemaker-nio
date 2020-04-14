public struct FileMakerConfiguration {
    public let hostname: String
    public let databaseName: String
    public let username: String
    public let password: String
    
    public init(hostname: String, databaseName: String, username: String, password: String) {
        self.hostname = hostname
        self.databaseName = databaseName
        self.username = username
        self.password = password
    }
}
