using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NBA_DAL.Repositories
{
    public class BaseRepository
    {
        private readonly string _connectionString;
        public BaseRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("dev") ?? "";
        }

        protected void ExecuteNonQuery(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(storedProcedureName, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddRange(parameters);
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
            }
        }

        protected T? Get<T>(string storedProcedureName, Func<IDataRecord, T> populationFunction, params SqlParameter[] parameters)
        {
            return List(storedProcedureName, populationFunction, parameters).SingleOrDefault();
        }

        protected List<T> List<T>(string storedProcedureName, Func<IDataRecord, T> populationFunction, params SqlParameter[] parameters)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand(storedProcedureName, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddRange(parameters);
                connection.Open();

                var results = new List<T>();
                
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(populationFunction(reader));
                    }
                }

                connection.Close();
                return results;
            }
        }

        protected SqlParameter GetSqlParameter(
            string name,
            SqlDbType sqlDbType,
            int? size = null,
            object? value = null,
            ParameterDirection direction = ParameterDirection.Input)
        {
            var parameter = new SqlParameter(name, sqlDbType)
            {
                Value = value,
                Direction = direction,
            };

            if (size.HasValue)
            {
                parameter.Size = size.Value;
            }

            return parameter;
        }
    }
}
