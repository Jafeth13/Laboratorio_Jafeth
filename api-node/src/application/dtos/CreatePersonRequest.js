class CreatePersonRequest {
    constructor(identification, name, email, birthDate) {
        this.identification = identification;
        this.name = name;
        this.email = email;
        this.birthDate = birthDate;
    }
}

module.exports = CreatePersonRequest;