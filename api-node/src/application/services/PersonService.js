const repository = require('../../infrastucture/repositories/PersonRepository');

class PersonService {

    async getAll() {
        return await repository.getAll();
    }

    async create(request) {

        if (!request.name || !request.email)
            throw new Error('Datos inválidos');

        return await repository.create(request);
    }
}

module.exports = new PersonService();