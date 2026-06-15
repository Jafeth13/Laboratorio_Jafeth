const { connectWithRetry } = require('../persistence/db');

class PersonRepository {

    async getAll() {
        const db = await connectWithRetry();

        const result = await db.request()
            .execute('sp_GetAllPersons');

        return result.recordset;
    }

    async create(person) {
        const db = await connectWithRetry();

        const result = await db.request()
            .input('pn_Identification', person.identification)
            .input('pn_Name', person.name)
            .input('pn_Email', person.email)
            .input('pd_BirthDate', person.birthDate)
            .execute('sp_CreatePerson');

        return result.recordset[0];
    }
}

module.exports = new PersonRepository();